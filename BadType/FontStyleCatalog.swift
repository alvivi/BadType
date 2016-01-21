// Copyright 2015 Alvaro Vilanova Vidal. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import UIKit


private let frameworkBundleIdentifier = "bar.hacking.BadType"
private let defaultCatalogName = "FontStylesCatalog"

// MARK: - FontStylesCatalog Class

public final class FontStylesCatalog {
  internal var fontStyles: [String: FontStyle] = [:]

  // MARK: Initialization

  public convenience init() throws {
    guard let bundle = NSBundle(identifier: frameworkBundleIdentifier) else {
      throw Error.FileNotFound
    }
    try self.init(withDefaultCatalogInBundle: bundle)
  }

  public convenience init(withDefaultCatalogInBundle bundle: NSBundle) throws {
    guard let filepath = bundle.pathForResource(defaultCatalogName, ofType: "plist") else {
      throw Error.FileNotFound
    }
    try self.init(contentsOfFile: filepath)
  }

  public convenience init(contentsOfFile filepath: String) throws {
    guard let array = NSArray(contentsOfFile: filepath) as? [NSObject] else {
      throw Error.FileNotFound
    }
    try self.init(fromArray: array)
  }

  public init(fromArray array: [NSObject]) throws {
    for object in array {
      guard let dictionary = object as? Dictionary<String, NSObject> else {
        throw Error.InvalidCatalog("cannot read a root entry as a dictionary")
      }
      let style = try FontStyle(fromDictionary: dictionary)
      fontStyles[style.name] = style
    }
  }

  internal static func catalogFromStoryboardTarget() throws -> FontStylesCatalog? {
    var catalog: FontStylesCatalog?
    let projectPaths = NSProcessInfo.processInfo().environment["IB_PROJECT_SOURCE_DIRECTORIES"]?.componentsSeparatedByString(",")
    guard let path = projectPaths?.first else {
      return nil
    }
    let directoryEnumerator = NSFileManager().enumeratorAtPath(path)
    while true {
      guard let filename = directoryEnumerator?.nextObject() as? String else {
        break
      }
      if filename.hasSuffix(defaultCatalogName + ".plist") {
        let currentCatalog = try FontStylesCatalog(contentsOfFile: NSString.pathWithComponents([path, filename]))
        if catalog == nil {
          catalog = currentCatalog
        } else {
          catalog?.joinInPlace(currentCatalog)
        }
      }
    }
    return catalog
  }

  internal func joinInPlace(other: FontStylesCatalog) {
    for (styleName, style) in other.fontStyles {
      fontStyles[styleName] = style
    }
  }

  // MARK: Font Utilities

  public func fontWithStyleName(name: String, defaultFont userDefaultFont: UIFont? = nil) -> UIFont {
    let defaultFont = userDefaultFont ?? UIFont.systemFontOfSize(UIFont.systemFontSize())
    let trimmedName = name.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceCharacterSet())
    guard let style = fontStyles[trimmedName] else {
      return defaultFont
    }
    guard let index = getSystemContentSizeCategoryIndex(BadType.contentSizeCategory) else {
      return defaultFont
    }
    let size = style.sizes[index]
    let traits = style.traits[index]
    let fontName = style.fontNames[index]
    let descriptor = fontName != nil ? UIFontDescriptor(name: fontName!, size: 0) : defaultFont.fontDescriptor()
    let font = UIFont(descriptor: descriptor.fontDescriptorWithSymbolicTraits(traits), size: size)
    font.fontStyle = trimmedName
    return font
  }
}

// MARK: - ContentSizeCategory Utilities

private func getSystemContentSizeCategoryIndex(category: String) -> Int? {
  switch category {
  case UIContentSizeCategoryExtraSmall:
    return 0
  case UIContentSizeCategorySmall:
    return 1
  case UIContentSizeCategoryMedium:
    return 2
  case UIContentSizeCategoryLarge:
    return 3
  case UIContentSizeCategoryExtraLarge:
    return 4
  case UIContentSizeCategoryExtraExtraLarge:
    return 5
  case UIContentSizeCategoryExtraExtraExtraLarge:
    return 6
  case UIContentSizeCategoryAccessibilityMedium:
    return 7
  case UIContentSizeCategoryAccessibilityLarge:
    return 8
  case UIContentSizeCategoryAccessibilityExtraLarge:
    return 9
  case UIContentSizeCategoryAccessibilityExtraExtraLarge:
    return 10
  case UIContentSizeCategoryAccessibilityExtraExtraExtraLarge:
    return 11
  default:
    return nil
  }
}
