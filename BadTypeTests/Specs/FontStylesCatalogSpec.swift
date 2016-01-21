// Copyright 2015 Alvaro Vilanova Vidal. All rights reserved.
// Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.

import Quick
import Nimble

@testable import BadType


class FontStylesCatalogSpec: QuickSpec {
  override func spec() {
    describe("FontStylesCatalog") {
      it("should throw an error when catalog file do not exists") {
      }
      
      it("should throw an error when catalog file root element is not an array") {
      }
      
      it("should throw an error when a catalog root entry is not a dictionary") {
        expect {
          try FontStylesCatalog(fromArray: [
            [
              "Style Name": "Foo",
              "Size Categories": [
                "Medium": [
                  "Size": 14,
                ],
              ],
            ],
            "To The Moon!",
          ])
        }.to(throwError())
      }
    }
    
    describe("Default FontStylesCatalog") {
      it("should find the default catalog") {
        expect{ try FontStylesCatalog() }.toNot(throwError())
      }
      
      it("should have 10 entries") {
        expect { () -> Void in
          let catalog = try FontStylesCatalog()
          expect(catalog.fontStyles.count).to(equal(10))
        }.toNot(throwError())
      }
    }
    
    describe("FontStyle") {
      it("should initialize with minimal contents") {
        expect {
          try FontStyle(fromDictionary: [
            "Style Name": "Foo",
            "Size Categories": [
              "Medium": [
                "Size": 14,
              ],
            ],
          ])
        }.toNot(throwError())
      }
      
      it("should initialize with a single trait") {
        expect {
          try FontStyle(fromDictionary: [
            "Style Name": "Foo",
            "Size Categories": [
              "Medium": [
                "Size": 14,
                "Traits": "Bold",
              ],
            ],
          ])
        }.toNot(throwError())
      }
      
      it("should initialize with multiple trait") {
        expect {
          try FontStyle(fromDictionary: [
            "Style Name": "Foo",
            "Size Categories": [
              "Medium": [
                "Size": 14,
                "Traits": ["Bold", "Italic"],
              ],
            ],
          ])
        }.toNot(throwError())
      }
      
      it("should throw an error when style name entry is not present") {
        expect {
          try FontStyle(fromDictionary: [
            "style name": "Foo", // Note lower case
            "Size Categories": [
              "Medium": [
                "Size": 14,
              ],
            ],
          ])
        }.to(throwError())
      }
      
      it("should throw an error when style name entry is not a string") {
        expect {
          try FontStyle(fromDictionary: [
            "Style Name": 42,
            "Size Categories": [
              "Medium": [
                "Size": 14,
              ],
            ],
          ])
        }.to(throwError())
      }
    
      it("should throw an error when size categories entry is not present") {
        expect {
          try FontStyle(fromDictionary: [
            "Style Name": "Foo",
            "size categories": [ // Note lower case
              "Medium": [
                "Size": 14,
              ],
            ],
          ])
        }.to(throwError())
      }
      
      it("should throw an error when size categories entry is not a dictionary") {
        expect {
          try FontStyle(fromDictionary: [
            "Style Name": "Foo",
            "Size Categories": [
              "Medium": "To The Moon!",
            ],
          ])
        }.to(throwError())
      }
     
      it("should throw an error when a size category has an invalid name") {
        expect {
          try FontStyle(fromDictionary: [
            "Style Name": "Foo",
            "Size Categories": [
              "medium": [ // Note lower case
                "Size": 14,
              ],
            ],
          ])
        }.to(throwError())
      }
     
      it("should throw an error when a size category value is not present") {
        expect {
          try FontStyle(fromDictionary: [
            "Style Name": "Foo",
            "Size Categories": [
              "Medium": [
              ],
            ],
          ])
        }.to(throwError())
      }
      
      it("should throw an error when a size category has an invalid value") {
        expect {
          try FontStyle(fromDictionary: [
            "Style Name": "Foo",
            "Size Categories": [
              "Medium": [
                "Size": -42,
              ],
            ],
          ])
        }.to(throwError())
      }
      
      it("should throw an error when a trait category value is invalid") {
        expect {
          try FontStyle(fromDictionary: [
            "Style Name": "Foo",
            "Size Categories": [
              "Medium": [
                "Size": 14,
                "Traits": "To the Moon",
              ],
            ],
          ])
        }.to(throwError())
      }
    }
    
    describe("FontStylesCatalog.fontWithStyleName") {
      it("should return the default font when style name is not valid") {
        expect { () -> Void in
          let catalog = try FontStylesCatalog()
          BadType.contentSizeCategory = UIContentSizeCategoryMedium
          let font = catalog.fontWithStyleName("TO THE MOON!")
          expect(font.fontName).to(match(UIFont.systemFontOfSize(0).fontName))
          expect(font.pointSize).to(equal(UIFont.systemFontSize()))
        }.toNot(throwError())
      }
      
      it("should trim style name") {
        expect { () -> Void in
          let catalog = try FontStylesCatalog()
          BadType.contentSizeCategory = UIContentSizeCategoryMedium
          let font = catalog.fontWithStyleName(" Headline    ")
          expect(font.pointSize).to(equal(19))
        }.toNot(throwError())
      }
      
      it("should works with no font override and no default font") {
        expect { () -> Void in
          let catalog = try FontStylesCatalog()
          BadType.contentSizeCategory = UIContentSizeCategoryMedium
          let font = catalog.fontWithStyleName("Headline")
          expect(font.fontName).to(match(UIFont.systemFontOfSize(0).fontName))
          expect(font.pointSize).to(equal(19))
        }.toNot(throwError())
      }
      
      it("should override fonts") {
        expect { () -> Void in
          let catalog = try FontStylesCatalog(fromArray: [
            [
              "Style Name": "Foo",
              "Size Categories": [
                "Medium": [
                  "Font Name": "Arial",
                  "Size": 14,
                ],
              ],
            ],
          ])
          BadType.contentSizeCategory = UIContentSizeCategoryMedium
          let defaultFont = UIFont(name: "Avenir", size: 20)!
          let font = catalog.fontWithStyleName("Foo", defaultFont: defaultFont)
          expect(font.fontName).to(match("Arial"))
          expect(font.pointSize).to(equal(14))
        }.toNot(throwError())
      }
    
      it("should set font name") {
        expect { () -> Void in
          let catalog = try FontStylesCatalog(fromArray: [
            [
              "Style Name": "Foo",
              "Size Categories": [
                "Medium": [
                  "Font Name": "Arial",
                  "Size": 14,
                ],
              ],
            ],
            ])
          BadType.contentSizeCategory = UIContentSizeCategoryMedium
          expect(catalog.fontWithStyleName("Foo").fontName).to(match("Arial"))
        }.toNot(throwError())
      }
    }
  }
}
