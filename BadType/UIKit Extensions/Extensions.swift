// Copyright 2015 Alvaro Vilanova Vidal. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// This file is needed to workaround
// https://openradar.appspot.com/23114017


import UIKit

// MARK: - UIButton

extension UIButton: FontStyleable {
  @IBInspectable public var fontStyle: NSString {
    get {
      return titleLabel?.fontStyle ?? ""
    }

    set {
      if let font = BadType.catalog?.fontWithStyleName(String(newValue), defaultFont: titleLabel?.font) {
        self.titleLabel?.font = font
      }
      BadType.addStyleable(self)
    }
  }
}

@IBDesignable public class BTButton: UIButton {
  // Intentionally empty
}

// MARK: - UILabel

extension UILabel: FontStyleable {
  @IBInspectable public var fontStyle: NSString {
    get {
      return font.fontStyle ?? ""
    }

    set {
      if let font = BadType.catalog?.fontWithStyleName(String(newValue), defaultFont: font) {
        self.font = font
      }
      BadType.addStyleable(self)
    }
  }
}


@IBDesignable public class BTLabel: UILabel {
  // Intentionally empty
}
