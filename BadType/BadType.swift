// Copyright 2015 Alvaro Vilanova Vidal. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import Foundation

public final class BadType: NSObject {
  public static var logFunction: (String -> Void) = { print($0) }
  public static var styleablesCount: Int { return styleables.count }

  public private(set) static var catalog: FontStylesCatalog? = {
    BadType.setupNotificationObserver()
    #if TARGET_INTERFACE_BUILDER
      do {
        return try FontStylesCatalog.catalogFromStoryboardTarget()
      } catch let error {
        fatalError("\(error)")
      }
    #else
      do {
        let catalog = try FontStylesCatalog()
        do {
          catalog.joinInPlace(try FontStylesCatalog(withDefaultCatalogInBundle: NSBundle.mainBundle()))
        } catch Error.FileNotFound {
          /* intentionally emtpy */
        } catch let error {
          logFunction("error \(error)")
        }
        return catalog
      } catch let error {
        logFunction("error \(error)")
        return nil
      }
    #endif
  }()

  public static var contentSizeCategory: String {
    get {
      #if TARGET_INTERFACE_BUILDER
        return BadType.overriddenContentSizeCategory ?? UIContentSizeCategoryMedium
      #else
        return BadType.overriddenContentSizeCategory ?? UIApplication.sharedApplication().preferredContentSizeCategory
      #endif
    }
    set {
      BadType.overriddenContentSizeCategory = newValue
    }
  }

  private static var sharedInstance = BadType()
  private static var styleables: NSHashTable = NSHashTable.weakObjectsHashTable()
  private static var overriddenContentSizeCategory: String? {
    didSet {
      if oldValue != overriddenContentSizeCategory {
        BadType.sharedInstance.updateStyleables()
      }
    }
  }

  private static func setupNotificationObserver() {
    let notificationCenter = NSNotificationCenter.defaultCenter()
    notificationCenter.addObserver(sharedInstance, selector: "updateStyleables",
      name: UIContentSizeCategoryDidChangeNotification, object: nil)
  }

  // MARK: Styleables Management

  public static func addStyleable(styleableObject: FontStyleable) {
    dispatch_async(dispatch_get_main_queue()) {
      styleables.addObject(styleableObject)
    }
  }

  @objc private func updateStyleables() {
    dispatch_async(dispatch_get_main_queue()) {
      var aliveStyleables = NSHashTable.weakObjectsHashTable()
      defer {
        BadType.styleables = aliveStyleables
      }
      let enumerator = BadType.styleables.objectEnumerator()
      while true {
        guard let styleableObject = enumerator.nextObject() as? FontStyleable else {
          break
        }
        styleableObject.updateFontStyle()
        aliveStyleables.addObject(styleableObject)
      }
    }
  }
}
