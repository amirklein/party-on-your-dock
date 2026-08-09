#!/usr/bin/env swift
import AppKit
import Foundation

/// party-on-your-dock CLI — list, extract, apply, and revert macOS app icons.

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

func printUsage() {
  fputs(
    """
    party-on-your-dock (poyd)

    Usage:
      poyd list [--apps-dir PATH]
      poyd extract [--apps-dir PATH] [--only NAME ...]
      poyd apply <theme> [--apps-dir PATH] [--only NAME ...]
      poyd revert [--apps-dir PATH] [--only NAME ...]
      poyd apply-one <AppName> <image.png>

    Themes live in themes/<theme>/*.png (filename = app name without .app).
    Originals are backed up to originals/ on extract / first apply.

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

func filteredApps(_ apps: [URL], only: Set<String>?) -> [URL] {
  guard let only else { return apps }
  return apps.filter { only.contains(appName(from: $0)) }
}

func cmdList(args: [String]) {
  var args = args
  let appsDir = parseAppsDir(from: &args)
  let apps = listApps(in: appsDir)
  for app in apps {
    print(appName(from: app))
  }
  fputs("(\(apps.count) apps in \(appsDir))\n", stderr)
}

func cmdExtract(args: [String]) {
  var args = args
  let appsDir = parseAppsDir(from: &args)
  let only = parseOnlyNames(from: &args)
  let apps = filteredApps(listApps(in: appsDir), only: only)

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

func applyImage(_ imageURL: URL, to app: URL) -> Bool {
  guard let image = loadImage(at: imageURL) else {
    fputs("fail: cannot load \(imageURL.path)\n", stderr)
    return false
  }
  ensureOriginalBackup(for: app)
  let success = NSWorkspace.shared.setIcon(image, forFile: app.path, options: [])
  if !success {
    fputs("fail: setIcon returned false for \(app.path)\n", stderr)
  }
  return success
}

func cmdApply(args: [String]) {
  var args = args
  guard let theme = args.first else {
    printUsage()
    exit(Int32(ExitCode.usage))
  }
  args.removeFirst()
  let appsDir = parseAppsDir(from: &args)
  let only = parseOnlyNames(from: &args)
  let themePath = themesDir.appendingPathComponent(theme)

  var isDir: ObjCBool = false
  guard FileManager.default.fileExists(atPath: themePath.path, isDirectory: &isDir), isDir.boolValue else {
    fputs("error: theme not found: \(themePath.path)\n", stderr)
    exit(Int32(ExitCode.failure))
  }

  let apps = filteredApps(listApps(in: appsDir), only: only)
  var ok = 0
  var skipped = 0
  for app in apps {
    let name = appName(from: app)
    let iconURL = themePath.appendingPathComponent("\(name).png")
    guard FileManager.default.fileExists(atPath: iconURL.path) else {
      skipped += 1
      continue
    }
    if applyImage(iconURL, to: app) {
      print("applied \(name)")
      ok += 1
    }
  }
  // Nudge Finder/Dock icon caches a bit
  NSWorkspace.shared.noteFileSystemChanged(appsDir)
  fputs("applied \(ok), skipped \(skipped) (no theme icon)\n", stderr)
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
    NSWorkspace.shared.noteFileSystemChanged(appsDir)
  } else {
    exit(Int32(ExitCode.failure))
  }
}

func cmdRevert(args: [String]) {
  var args = args
  let appsDir = parseAppsDir(from: &args)
  let only = parseOnlyNames(from: &args)
  let apps = filteredApps(listApps(in: appsDir), only: only)

  var ok = 0
  for app in apps {
    let name = appName(from: app)
    let original = originalsDir.appendingPathComponent("\(name).png")
    if FileManager.default.fileExists(atPath: original.path),
       let image = loadImage(at: original) {
      if NSWorkspace.shared.setIcon(image, forFile: app.path, options: []) {
        print("reverted \(name) (from originals/)")
        ok += 1
        continue
      }
    }
    // Clear custom icon → macOS falls back to bundle icon
    if NSWorkspace.shared.setIcon(nil, forFile: app.path, options: []) {
      print("reverted \(name) (cleared custom icon)")
      ok += 1
    } else {
      fputs("fail \(name)\n", stderr)
    }
  }
  NSWorkspace.shared.noteFileSystemChanged(appsDir)
  fputs("reverted \(ok)/\(apps.count)\n", stderr)
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
case "extract":
  cmdExtract(args: args)
case "apply":
  cmdApply(args: args)
case "apply-one":
  cmdApplyOne(args: args)
case "revert":
  cmdRevert(args: args)
case "help", "-h", "--help":
  printUsage()
default:
  fputs("unknown command: \(command)\n\n", stderr)
  printUsage()
  exit(Int32(ExitCode.usage))
}
