// Copyright 2015 Alvaro Vilanova Vidal. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

// This file is needed to workaround
// https://openradar.appspot.com/23114017

import UIKit
import BadType


@IBDesignable public class BTButton: UIButton {
  @IBInspectable override public var fontStyle: NSString {
    get {
      return super.fontStyle
    }
    set {
      super.fontStyle = newValue
    }
  }
}

@IBDesignable public class BTLabel: UILabel {
  @IBInspectable override public var fontStyle: NSString {
    get {
      return super.fontStyle
    }
    set {
      super.fontStyle = newValue
    }
  }
}
