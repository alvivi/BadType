// Copyright 2015 Alvaro Vilanova Vidal. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import UIKit


extension UIButton: FontStyleable {
  public var fontStyle: NSString {
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
