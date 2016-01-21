// Copyright 2015 Alvaro Vilanova Vidal. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import UIKit

private var fontStyleAssociatedObjectKey: UInt8 = 0

extension UIFont {
  var fontStyle: String? {
    get {
      return objc_getAssociatedObject(self, &fontStyleAssociatedObjectKey) as? String
    }
    set {
      objc_setAssociatedObject(self, &fontStyleAssociatedObjectKey, newValue, objc_AssociationPolicy.OBJC_ASSOCIATION_COPY_NONATOMIC)
    }
  }
}
