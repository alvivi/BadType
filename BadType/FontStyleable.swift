// Copyright 2015 Alvaro Vilanova Vidal. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import UIKit


public protocol FontStyleable: AnyObject {
  var fontStyle: NSString { get set }
}

internal extension FontStyleable {
  internal func updateFontStyle() {
    let style = fontStyle
    fontStyle = style
  }
}
