// Copyright 2015 Alvaro Vilanova Vidal. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import Foundation

public enum Error: ErrorType {
  case FileNotFound
  case InvalidCatalog(String)
  case InvalidStyle(String)
}

extension Error: CustomStringConvertible {
  public var description: String {
    switch self {
    case .FileNotFound:
      return "file not found"
    case .InvalidCatalog(let details):
      return "ivalid catalog, \(details)"
    case .InvalidStyle(let details):
      return "ivalid style, \(details)"
    }
  }
}
