// Copyright 2015 Alvaro Vilanova Vidal. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import UIKit


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
