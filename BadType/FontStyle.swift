// Copyright 2015 Alvaro Vilanova Vidal. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import UIKit


private let styleNameKey = "Style Name"
private let sizeCategoriesKey = "Size Categories"
private let categoryAttributeSizeKey = "Size"
private let categoryAttributeTraitsKey = "Traits"
private let categoryAttributeFontNameKey = "Font Name"

// MARK: - FontStyle Struct

internal struct FontStyle {
  let name: String
  let sizes: [CGFloat]
  let traits: [UIFontDescriptorSymbolicTraits]
  let fontNames: [String?]

  init(fromDictionary dictionary: Dictionary<String, AnyObject>) throws {
    guard let name = dictionary[styleNameKey] as? String else {
      throw Error.InvalidStyle("cannot read style name")
    }
    self.name = name

    guard let sizesCategories = dictionary[sizeCategoriesKey] as? Dictionary<String, AnyObject> else {
      throw Error.InvalidStyle("cannot read size categories")
    }
    var sizes = Array<CGFloat>(count: 12, repeatedValue: 14)
    var traits = Array<UIFontDescriptorSymbolicTraits>(count: 12, repeatedValue: [])
    var fontNames = Array<String?>(count: 12, repeatedValue: nil)
    for (categoryName, category) in sizesCategories {
      guard let index = getCategoryNameIndex(categoryName) else {
        throw Error.InvalidStyle("invalid size category name \"\(categoryName)\"")
      }
      guard let size = category[categoryAttributeSizeKey] as? NSNumber else {
        throw Error.InvalidStyle("invalid size category \"\(categoryName)\" value")
      }
      if size.floatValue < 0 {
        throw Error.InvalidStyle("invalid negative size value")
      }
      sizes[index] = CGFloat(size.doubleValue)
      if let object = category[categoryAttributeTraitsKey] as? NSObject {
        traits[index] = try UIFontDescriptorSymbolicTraits.tratisFromObject(object)
      }
      if let fontNameString = category[categoryAttributeFontNameKey] as? String {
        fontNames[index] = fontNameString
      }
    }
    self.sizes = sizes
    self.traits = traits
    self.fontNames = fontNames
  }
}

// MARK: - UIFontDescriptorSymbolicTraits Extension

private extension UIFontDescriptorSymbolicTraits {
  private static func tratisFromObject(object: NSObject) throws -> UIFontDescriptorSymbolicTraits {
    if let traitString = object as? String {
      return try traitsFromString(traitString)
    }
    if let traitsArray = object as? [NSObject] {
      return try traitsFromArray(traitsArray)
    }
    return []
  }

  private static func traitsFromArray(array: [NSObject]) throws -> UIFontDescriptorSymbolicTraits {
    var traits: UIFontDescriptorSymbolicTraits = []
    for object in array {
      guard let traitString = object as? String else {
        continue
      }
      traits.unionInPlace(try traitsFromString(traitString) )
    }
    return traits
  }

  // swiftlint:disable function_body_length
  private static func traitsFromString(traitString: String) throws -> UIFontDescriptorSymbolicTraits {
    switch traitString {
    case "Italic":
      return .TraitItalic
    case "Bold":
      return .TraitBold
    case "Expanded":
      return .TraitExpanded
    case "Condensed":
      return .TraitCondensed
    case "MonoSpace":
      return .TraitMonoSpace
    case "Vertical":
      return .TraitVertical
    case "UIOptimized":
      return .TraitUIOptimized
    case "TightLeading":
      return .TraitTightLeading
    case "LooseLeading":
      return .TraitLooseLeading
    case "Mask":
      return .ClassMask
    case "Unknown":
      return .ClassUnknown
    case "OldStyleSerifs":
      return .ClassOldStyleSerifs
    case "TransitionalSerifs":
      return .ClassTransitionalSerifs
    case "ModernSerifs":
      return .ClassModernSerifs
    case "ClarendonSerifs":
      return .ClassClarendonSerifs
    case "SlabSerifs":
      return .ClassSlabSerifs
    case "FreeformSerifs":
      return .ClassFreeformSerifs
    case "SansSerif":
      return .ClassSansSerif
    case "Ornamentals":
      return .ClassOrnamentals
    case "Scripts":
      return .ClassScripts
    case "Symbolic":
      return .ClassSymbolic
    default:
      throw Error.InvalidStyle("trait \"\(traitString)\" is invalid")
    }
  }
  // swiftlint:enable function_body_length
}

private func getCategoryNameIndex(name: String) -> Int? {
  switch name {
  case "ExtraSmall":
    return 0
  case "Small":
    return 1
  case "Medium":
    return 2
  case "Large":
    return 3
  case "ExtraLarge":
    return 4
  case "ExtraExtraLarge":
    return 5
  case "ExtraExtraExtraLarge":
    return 6
  case "AccessibilityMedium":
    return 7
  case "AccessibilityLarge":
    return 8
  case "AccessibilityExtraLarge":
    return 9
  case "AccessibilityExtraExtraLarge":
    return 10
  case "AccessibilityExtraExtraExtraLarge":
    return 11
  default:
    return nil
  }
}
