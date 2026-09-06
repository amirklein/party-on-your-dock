#!/usr/bin/env swift
import AppKit
import Foundation

/// party-on-your-dock CLI — list, extract, apply, and revert macOS app icons.
///
/// SAFETY: Only set/clear *custom icons* on the `.app` wrapper (fileicon / NSWorkspace.setIcon).
/// NEVER write inside `Foo.app/Contents/` (no .icns / Assets.car / Info.plist / codesign --sign).
/// Bundle surgery breaks Gatekeeper (“damaged”) and breaks signed features (e.g. ChatGPT connectors).

let repoRoot = URL(fileURLWithPath: #filePath)
  .deletingLastPathComponent()
  .deletingLastPathComponent()

let originalsDir = repoRoot.appendingPathComponent("originals")
let themesDir = repoRoot.appendingPathComponent("themes")
let defaultAppsDir = "/Applications"

enum ExitCode {
  static let ok = 0
  static let usage = 1
  static let failure = 2
}

let poydVersion = "0.1.0"

func printUsage() {
  fputs(
    """
    party-on-your-dock (poyd)

    Safe custom icons only — never modifies files inside .app/Contents.

    Usage:
      poyd list [--apps-dir PATH] [--dock]
      poyd dock
      poyd extract [--apps-dir PATH] [--dock] [--only NAME ...]
      poyd apply <theme> [--apps-dir PATH] [--dock] [--dry-run] [--only NAME ...]
      poyd apply-one <AppName> <image.png>
      poyd revert [--apps-dir PATH] [--dock] [--dry-run] [--only NAME ...]
      poyd verify [--apps-dir PATH] [--dock] [--only NAME ...]
      poyd status [--apps-dir PATH] [--dock] [--only NAME ...]
      poyd doctor
      poyd version
      poyd missing <theme> [--apps-dir PATH] [--dock] [--only NAME ...]
      poyd themes
      poyd init-theme <slug>

    --dock limits to apps pinned in the macOS Dock (skips /System/...).
    Themes: themes/<theme>/*.png (filename = app name without .app).
    Originals PNG renders: originals/ (art reference only; never written into bundles).
    init-theme creates themes/<slug>/ for a new pack (ASCII slug, hyphens).

    """,
    stderr
  )
}

func appName(from url: URL) -> String {
  url.deletingPathExtension().lastPathComponent
}

func listApps(in appsDir: String) -> [URL] {
  let fm = FileManager.default
  guard let items = try? fm.contentsOfDirectory(
    at: URL(fileURLWithPath: appsDir),
    includingPropertiesForKeys: [.isDirectoryKey],
    options: [.skipsHiddenFiles]
  ) else {
    return []
  }
  return items
    .filter { $0.pathExtension == "app" }
    .sorted { $0.lastPathComponent.localizedCaseInsensitiveCompare($1.lastPathComponent) == .orderedAscending }
}

func ensureDir(_ url: URL) throws {
  try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
}

func saveIcon(_ image: NSImage, to url: URL, size: CGFloat = 1024) throws {
  let rep = NSBitmapImageRep(
    bitmapDataPlanes: nil,
    pixelsWide: Int(size),
    pixelsHigh: Int(size),
    bitsPerSample: 8,
    samplesPerPixel: 4,
    hasAlpha: true,
    isPlanar: false,
    colorSpaceName: .deviceRGB,
    bytesPerRow: 0,
    bitsPerPixel: 0
  )!
  rep.size = NSSize(width: size, height: size)
  NSGraphicsContext.saveGraphicsState()
  NSGraphicsContext.current = NSGraphicsContext(bitmapImageRep: rep)
  image.draw(
    in: NSRect(x: 0, y: 0, width: size, height: size),
    from: .zero,
    operation: .copy,
    fraction: 1.0
  )
  NSGraphicsContext.restoreGraphicsState()
  guard let png = rep.representation(using: .png, properties: [:]) else {
    throw NSError(domain: "poyd", code: 1, userInfo: [NSLocalizedDescriptionKey: "Failed to encode PNG for \(url.lastPathComponent)"])
  }
  try png.write(to: url)
}

func loadImage(at url: URL) -> NSImage? {
  NSImage(contentsOf: url)
}

func parseOnlyNames(from args: inout [String]) -> Set<String>? {
  guard let idx = args.firstIndex(of: "--only") else { return nil }
  args.remove(at: idx)
  var names = Set<String>()
  while idx < args.count, !args[idx].hasPrefix("--") {
    names.insert(args.remove(at: idx))
  }
  return names.isEmpty ? nil : names
}

func parseAppsDir(from args: inout [String]) -> String {
  guard let idx = args.firstIndex(of: "--apps-dir") else { return defaultAppsDir }
  args.remove(at: idx)
  guard idx < args.count else {
    fputs("error: --apps-dir needs a path\n", stderr)
    exit(Int32(ExitCode.usage))
  }
  return args.remove(at: idx)
}

func parseDockFlag(from args: inout [String]) -> Bool {
  guard let idx = args.firstIndex(of: "--dock") else { return false }
  args.remove(at: idx)
  return true
}

func parseDryRunFlag(from args: inout [String]) -> Bool {
  guard let idx = args.firstIndex(of: "--dry-run") else { return false }
  args.remove(at: idx)
  return true
}

func filteredApps(_ apps: [URL], only: Set<String>?) -> [URL] {
  guard let only else { return apps }
  return apps.filter { only.contains(appName(from: $0)) }
}

/// Apps pinned in the Dock (`persistent-apps`), excluding /System paths.
func dockAppURLs() -> [URL] {
  let result = run("/usr/bin/defaults", ["export", "com.apple.dock", "-"], capture: true)
  guard result.status == 0,
        let data = result.stdout.data(using: .utf8),
        let plist = try? PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any],
        let persistent = plist["persistent-apps"] as? [[String: Any]]
  else {
    fputs("warn: could not read Dock preferences\n", stderr)
    return []
  }

  var urls: [URL] = []
  var seen = Set<String>()
  for entry in persistent {
    guard let tile = entry["tile-data"] as? [String: Any] else { continue }
    var path: String?
    if let fileData = tile["file-data"] as? [String: Any],
       let urlString = fileData["_CFURLString"] as? String {
      if urlString.hasPrefix("file://"),
         let u = URL(string: urlString) {
        path = u.path
      } else {
        path = urlString
      }
    }
    guard var path, path.hasSuffix(".app") else { continue }
    while path.hasSuffix("/") { path.removeLast() }
    if path.hasPrefix("/System/") { continue }
    if seen.contains(path) { continue }
    seen.insert(path)
    let url = URL(fileURLWithPath: path)
    guard FileManager.default.fileExists(atPath: url.path) else { continue }
    urls.append(url)
  }
  return urls.sorted {
    $0.lastPathComponent.localizedCaseInsensitiveCompare($1.lastPathComponent) == .orderedAscending
  }
}

func resolveTargetApps(appsDir: String, only: Set<String>?, dockOnly: Bool) -> [URL] {
  let base = dockOnly ? dockAppURLs() : listApps(in: appsDir)
  return filteredApps(base, only: only)
}

@discardableResult
func run(_ launchPath: String, _ arguments: [String], capture: Bool = false) -> (status: Int32, stdout: String) {
  let proc = Process()
  proc.executableURL = URL(fileURLWithPath: launchPath)
  proc.arguments = arguments
  let outPipe = Pipe()
  let errPipe = Pipe()
  if capture {
    proc.standardOutput = outPipe
    proc.standardError = errPipe
  } else {
    proc.standardOutput = FileHandle.nullDevice
    proc.standardError = FileHandle.nullDevice
  }
  do {
    try proc.run()
    proc.waitUntilExit()
  } catch {
    return (127, "")
  }
  var text = ""
  if capture {
    let out = outPipe.fileHandleForReading.readDataToEndOfFile()
    let err = errPipe.fileHandleForReading.readDataToEndOfFile()
    text = String(data: out + err, encoding: .utf8) ?? ""
  }
  return (proc.terminationStatus, text)
}

func which(_ name: String) -> String? {
  let result = run("/usr/bin/which", [name], capture: true)
  guard result.status == 0 else { return nil }
  let path = result.stdout.trimmingCharacters(in: .whitespacesAndNewlines)
  return path.isEmpty ? nil : path
}

/// Returns true if codesign considers the app valid (or unsigned / no signature to check).
func codesignLooksValid(_ app: URL) -> Bool {
  let result = run("/usr/bin/codesign", ["--verify", "--deep", "--strict", app.path], capture: true)
  if result.status == 0 { return true }
  // Unsigned apps (or missing signature) — don't treat as our breakage.
  if result.stdout.contains("code object is not signed at all") { return true }
  return false
}

func signatureSummary(_ app: URL) -> String {
  let result = run("/usr/bin/codesign", ["-dv", "--verbose=2", app.path], capture: true)
  let lines = result.stdout.split(separator: "\n").map(String.init)
  let interesting = lines.filter {
    $0.hasPrefix("Authority=") || $0.hasPrefix("Signature=") || $0.hasPrefix("TeamIdentifier=")
      || $0.hasPrefix("Identifier=")
  }
  if interesting.isEmpty { return result.stdout.trimmingCharacters(in: .whitespacesAndNewlines) }
  return interesting.joined(separator: "; ")
}

func flushIconCaches(note appsDir: String? = nil) {
  let home = FileManager.default.homeDirectoryForCurrentUser
  let caches = [
    home.appendingPathComponent("Library/Caches/com.apple.iconservices.store"),
    home.appendingPathComponent("Library/Caches/com.apple.iconservices"),
    home.appendingPathComponent("Library/Caches/com.apple.dock"),
  ]
  for url in caches {
    try? FileManager.default.removeItem(at: url)
  }
  if let appsDir {
    NSWorkspace.shared.noteFileSystemChanged(appsDir)
  }
  _ = run("/usr/bin/killall", ["Finder"])
  _ = run("/usr/bin/killall", ["Dock"])
}

func cmdList(args: [String]) {
  var args = args
  let appsDir = parseAppsDir(from: &args)
  let dockOnly = parseDockFlag(from: &args)
  let apps = resolveTargetApps(appsDir: appsDir, only: nil, dockOnly: dockOnly)
  for app in apps {
    print(appName(from: app))
  }
  let scope = dockOnly ? "Dock" : appsDir
  fputs("(\(apps.count) apps in \(scope))\n", stderr)
}

func cmdDock(args: [String]) {
  _ = args
  let apps = dockAppURLs()
  for app in apps {
    print("\(appName(from: app))\t\(app.path)")
  }
  fputs("(\(apps.count) Dock apps)\n", stderr)
}

func cmdExtract(args: [String]) {
  var args = args
  let appsDir = parseAppsDir(from: &args)
  let dockOnly = parseDockFlag(from: &args)
  let only = parseOnlyNames(from: &args)
  let apps = resolveTargetApps(appsDir: appsDir, only: only, dockOnly: dockOnly)

  do {
    try ensureDir(originalsDir)
  } catch {
    fputs("error: \(error)\n", stderr)
    exit(Int32(ExitCode.failure))
  }

  var ok = 0
  for app in apps {
    let name = appName(from: app)
    let dest = originalsDir.appendingPathComponent("\(name).png")
    let icon = NSWorkspace.shared.icon(forFile: app.path)
    icon.size = NSSize(width: 1024, height: 1024)
    do {
      try saveIcon(icon, to: dest)
      print("extracted \(name)")
      ok += 1
    } catch {
      fputs("fail \(name): \(error)\n", stderr)
    }
  }
  fputs("extracted \(ok)/\(apps.count)\n", stderr)
}

func ensureOriginalBackup(for app: URL) {
  let name = appName(from: app)
  let dest = originalsDir.appendingPathComponent("\(name).png")
  if FileManager.default.fileExists(atPath: dest.path) { return }
  try? ensureDir(originalsDir)
  let icon = NSWorkspace.shared.icon(forFile: app.path)
  icon.size = NSSize(width: 1024, height: 1024)
  try? saveIcon(icon, to: dest)
}

func clearCustomIcon(on app: URL) -> Bool {
  if let fileicon = which("fileicon"),
     run(fileicon, ["rm", app.path]).status == 0 {
    return true
  }
  return NSWorkspace.shared.setIcon(nil, forFile: app.path, options: [])
}

/// Apply a theme PNG as a *custom icon only*. Never touches Contents/.
func applyImage(_ imageURL: URL, to app: URL) -> Bool {
  guard FileManager.default.fileExists(atPath: imageURL.path) else {
    fputs("fail: missing image \(imageURL.path)\n", stderr)
    return false
  }

  // Refuse using an in-bundle path as the theme image source.
  if imageURL.path.contains("/Contents/") {
    fputs("refuse: will not use an in-bundle path as icon source for apply (\(imageURL.path))\n", stderr)
    return false
  }

  let beforeOK = codesignLooksValid(app)
  ensureOriginalBackup(for: app)

  var applied = false
  if let fileicon = which("fileicon"),
     run(fileicon, ["set", app.path, imageURL.path]).status == 0 {
    applied = true
  } else if let image = loadImage(at: imageURL) {
    applied = NSWorkspace.shared.setIcon(image, forFile: app.path, options: [])
    if !applied {
      fputs("fail: setIcon returned false for \(app.path)\n", stderr)
    }
  } else {
    fputs("fail: cannot load \(imageURL.path)\n", stderr)
    return false
  }

  guard applied else { return false }

  // Custom icons must never invalidate code signature. If they somehow did, roll back.
  let afterOK = codesignLooksValid(app)
  if beforeOK && !afterOK {
    fputs("refuse/rollback: \(appName(from: app)) signature broke after icon apply — clearing custom icon. Never patch Contents/ or codesign --sign.\n", stderr)
    _ = clearCustomIcon(on: app)
    return false
  }
  if !afterOK {
    fputs("warn: \(appName(from: app)) already has an invalid signature (\(signatureSummary(app)))\n", stderr)
  }
  return true
}

func cmdApply(args: [String]) {
  var args = args
  guard let theme = args.first else {
    printUsage()
    exit(Int32(ExitCode.usage))
  }
  args.removeFirst()
  let appsDir = parseAppsDir(from: &args)
  let dockOnly = parseDockFlag(from: &args)
  let dryRun = parseDryRunFlag(from: &args)
  let only = parseOnlyNames(from: &args)
  let themePath = themesDir.appendingPathComponent(theme)

  var isDir: ObjCBool = false
  guard FileManager.default.fileExists(atPath: themePath.path, isDirectory: &isDir), isDir.boolValue else {
    fputs("error: theme not found: \(themePath.path)\n", stderr)
    exit(Int32(ExitCode.failure))
  }

  let apps = resolveTargetApps(appsDir: appsDir, only: only, dockOnly: dockOnly)
  var ok = 0
  var skipped = 0
  for app in apps {
    let name = appName(from: app)
    let iconURL = themePath.appendingPathComponent("\(name).png")
    guard FileManager.default.fileExists(atPath: iconURL.path) else {
      skipped += 1
      continue
    }
    if dryRun {
      print("would apply \(name)")
      ok += 1
    } else if applyImage(iconURL, to: app) {
      print("applied \(name)")
      ok += 1
    }
  }
  if !dryRun && ok > 0 { flushIconCaches(note: appsDir) }
  let verb = dryRun ? "would apply" : "applied"
  fputs("\(verb) \(ok), skipped \(skipped) (no theme icon)\n", stderr)
}

func cmdApplyOne(args: [String]) {
  guard args.count >= 2 else {
    printUsage()
    exit(Int32(ExitCode.usage))
  }
  let name = args[0].replacingOccurrences(of: ".app", with: "")
  let imagePath = args[1]
  let appsDir = defaultAppsDir
  let app = URL(fileURLWithPath: appsDir).appendingPathComponent("\(name).app")
  guard FileManager.default.fileExists(atPath: app.path) else {
    fputs("error: app not found: \(app.path)\n", stderr)
    exit(Int32(ExitCode.failure))
  }
  let imageURL = URL(fileURLWithPath: imagePath)
  if applyImage(imageURL, to: app) {
    print("applied \(name)")
    flushIconCaches(note: appsDir)
  } else {
    exit(Int32(ExitCode.failure))
  }
}

func cmdRevert(args: [String]) {
  var args = args
  let appsDir = parseAppsDir(from: &args)
  let dockOnly = parseDockFlag(from: &args)
  let dryRun = parseDryRunFlag(from: &args)
  let only = parseOnlyNames(from: &args)
  let apps = resolveTargetApps(appsDir: appsDir, only: only, dockOnly: dockOnly)

  var ok = 0
  for app in apps {
    let name = appName(from: app)
    if dryRun {
      if hasCustomIcon(app) {
        print("would revert \(name)")
        ok += 1
      }
      continue
    }
    // Clear custom icon only — stock bundle icon returns.
    // Never re-apply originals/*.png; never restore Contents/Resources/*.icns.
    if clearCustomIcon(on: app) {
      print("reverted \(name) (cleared custom icon)")
      ok += 1
    } else {
      fputs("fail \(name)\n", stderr)
    }
  }
  if !dryRun && ok > 0 { flushIconCaches(note: appsDir) }
  let verb = dryRun ? "would revert" : "reverted"
  fputs("\(verb) \(ok)/\(apps.count)\n", stderr)
}

func cmdVerify(args: [String]) {
  var args = args
  let appsDir = parseAppsDir(from: &args)
  let dockOnly = parseDockFlag(from: &args)
  let only = parseOnlyNames(from: &args)
  let apps = resolveTargetApps(appsDir: appsDir, only: only, dockOnly: dockOnly)
  var bad = 0
  for app in apps {
    let name = appName(from: app)
    if codesignLooksValid(app) {
      print("ok \(name)")
    } else {
      bad += 1
      fputs("BAD \(name): \(signatureSummary(app))\n", stderr)
      print("bad \(name)")
    }
  }
  fputs("verify: \(apps.count - bad) ok, \(bad) bad\n", stderr)
  if bad > 0 { exit(Int32(ExitCode.failure)) }
}

func hasCustomIcon(_ app: URL) -> Bool {
  if let fileicon = which("fileicon") {
    let result = run(fileicon, ["test", app.path], capture: true)
    let text = result.stdout.lowercased()
    if text.contains("has custom icon") { return true }
    if text.contains("has no custom icon") { return false }
  }
  // Fallback: Icon\r resource file present on the wrapper
  let iconFile = app.appendingPathComponent("Icon\r")
  return FileManager.default.fileExists(atPath: iconFile.path)
}

func cmdStatus(args: [String]) {
  var args = args
  let appsDir = parseAppsDir(from: &args)
  let dockOnly = parseDockFlag(from: &args)
  let only = parseOnlyNames(from: &args)
  let apps = resolveTargetApps(appsDir: appsDir, only: only, dockOnly: dockOnly)
  var custom = 0
  for app in apps {
    let name = appName(from: app)
    let themed = hasCustomIcon(app)
    if themed { custom += 1 }
    print("\(themed ? "custom" : "stock")\t\(name)")
  }
  fputs("status: \(custom) custom, \(apps.count - custom) stock\n", stderr)
}

func cmdDoctor(args: [String]) {
  _ = args
  var failed = 0

  func check(_ label: String, ok: Bool, hint: String) {
    if ok {
      print("ok\t\(label)")
    } else {
      failed += 1
      print("fail\t\(label)")
      fputs("hint: \(hint)\n", stderr)
    }
  }

  let swiftOK = FileManager.default.isExecutableFile(atPath: "/usr/bin/swift")
    || which("swift") != nil
  check("swift", ok: swiftOK, hint: "install Xcode Command Line Tools (`xcode-select --install`)")

  let fileiconOK = which("fileicon") != nil
  check("fileicon", ok: fileiconOK, hint: "brew install fileicon")

  let poydURL = repoRoot.appendingPathComponent("scripts/poyd")
  let poydOK = FileManager.default.isExecutableFile(atPath: poydURL.path)
  check("scripts/poyd executable", ok: poydOK, hint: "chmod +x scripts/poyd")

  let appsOK = FileManager.default.fileExists(atPath: defaultAppsDir)
  check("/Applications readable", ok: appsOK, hint: "this tool expects apps in /Applications")

  fputs("doctor: \(failed == 0 ? "ready" : "\(failed) check(s) failed")\n", stderr)
  if failed > 0 { exit(Int32(ExitCode.failure)) }
}

func normalizeThemeSlug(_ raw: String) -> String {
  let lowered = raw.lowercased()
  var out = ""
  var lastHyphen = false
  for ch in lowered {
    if ch.isLetter || ch.isNumber {
      out.append(ch)
      lastHyphen = false
    } else if !lastHyphen {
      out.append("-")
      lastHyphen = true
    }
  }
  while out.hasPrefix("-") { out.removeFirst() }
  while out.hasSuffix("-") { out.removeLast() }
  return out
}

func cmdThemes(args: [String]) {
  _ = args
  let fm = FileManager.default
  guard let items = try? fm.contentsOfDirectory(
    at: themesDir,
    includingPropertiesForKeys: [.isDirectoryKey],
    options: [.skipsHiddenFiles]
  ) else {
    fputs("error: cannot read \(themesDir.path)\n", stderr)
    exit(Int32(ExitCode.failure))
  }
  let dirs = items
    .filter { url in
      (try? url.resourceValues(forKeys: [.isDirectoryKey]).isDirectory) == true
    }
    .sorted { $0.lastPathComponent.localizedCaseInsensitiveCompare($1.lastPathComponent) == .orderedAscending }

  if dirs.isEmpty {
    fputs("(no theme packs yet — try: ./scripts/poyd init-theme n64)\n", stderr)
    return
  }
  for dir in dirs {
    let pngs = (try? fm.contentsOfDirectory(at: dir, includingPropertiesForKeys: nil))?
      .filter { $0.pathExtension.lowercased() == "png" } ?? []
    print("\(dir.lastPathComponent)\t\(pngs.count) icons")
  }
  fputs("(\(dirs.count) theme packs)\n", stderr)
}

func cmdInitTheme(args: [String]) {
  guard let raw = args.first else {
    fputs("usage: poyd init-theme <slug>\n", stderr)
    exit(Int32(ExitCode.usage))
  }
  let slug = normalizeThemeSlug(raw)
  guard !slug.isEmpty else {
    fputs("error: empty theme slug after normalizing \(raw)\n", stderr)
    exit(Int32(ExitCode.usage))
  }
  let dir = themesDir.appendingPathComponent(slug)
  if FileManager.default.fileExists(atPath: dir.path) {
    fputs("theme already exists: \(dir.path)\n", stderr)
    exit(Int32(ExitCode.failure))
  }
  do {
    try ensureDir(dir)
    let readme = dir.appendingPathComponent("README.md")
    let body = """
    # \(slug)

    Drop logo-only transparent PNGs here named exactly like `./scripts/poyd list` apps:

    ```
    \(slug)/Slack.png
    \(slug)/Spotify.png
    ```

    Then:

    ```bash
    ./scripts/poyd apply \(slug)
    ```

    """
    try body.write(to: readme, atomically: true, encoding: .utf8)
    print(dir.path)
    fputs("created theme pack \(slug)\n", stderr)
  } catch {
    fputs("error: \(error)\n", stderr)
    exit(Int32(ExitCode.failure))
  }
}


func cmdVersion(args: [String]) {
  _ = args
  print(poydVersion)
}


func cmdMissing(args: [String]) {
  var args = args
  guard let theme = args.first else {
    fputs("usage: poyd missing <theme> [--dock] [--only NAME ...]\n", stderr)
    exit(Int32(ExitCode.usage))
  }
  args.removeFirst()
  let appsDir = parseAppsDir(from: &args)
  let dockOnly = parseDockFlag(from: &args)
  let only = parseOnlyNames(from: &args)
  let themePath = themesDir.appendingPathComponent(theme)
  var isDir: ObjCBool = false
  guard FileManager.default.fileExists(atPath: themePath.path, isDirectory: &isDir), isDir.boolValue else {
    fputs("error: theme not found: \(themePath.path)\n", stderr)
    exit(Int32(ExitCode.failure))
  }

  let apps = resolveTargetApps(appsDir: appsDir, only: only, dockOnly: dockOnly)
  var missing = 0
  for app in apps {
    let name = appName(from: app)
    let iconURL = themePath.appendingPathComponent("\(name).png")
    if FileManager.default.fileExists(atPath: iconURL.path) {
      print("present\t\(name)")
    } else {
      missing += 1
      print("missing\t\(name)")
    }
  }
  fputs("missing: \(missing)/\(apps.count) without \(theme) icon\n", stderr)
  if missing > 0 { exit(Int32(ExitCode.failure)) }
}

// MARK: - main

var args = Array(CommandLine.arguments.dropFirst())
guard let command = args.first else {
  printUsage()
  exit(Int32(ExitCode.usage))
}
args.removeFirst()

switch command {
case "list":
  cmdList(args: args)
case "dock":
  cmdDock(args: args)
case "extract":
  cmdExtract(args: args)
case "apply":
  cmdApply(args: args)
case "apply-one":
  cmdApplyOne(args: args)
case "revert":
  cmdRevert(args: args)
case "verify":
  cmdVerify(args: args)
case "status":
  cmdStatus(args: args)
case "doctor":
  cmdDoctor(args: args)
case "version", "--version", "-v":
  cmdVersion(args: args)
case "missing":
  cmdMissing(args: args)
case "themes":
  cmdThemes(args: args)
case "init-theme":
  cmdInitTheme(args: args)
case "help", "-h", "--help":
  printUsage()
default:
  fputs("unknown command: \(command)\n\n", stderr)
  printUsage()
  exit(Int32(ExitCode.usage))
}
