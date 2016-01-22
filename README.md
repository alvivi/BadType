![Bad Type Logo](https://cloud.githubusercontent.com/assets/23727/12509092/64af7190-c100-11e5-8ccb-8957005b3400.png)

[![GitHub license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://raw.githubusercontent.com/alvivi/BadType/master/LICENSE.md)
![Platform](https://img.shields.io/badge/plaform-ios-lightgrey.svg)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Use [iOS DynamicType](https://developer.apple.com/library/ios/documentation/StringsTextFonts/Conceptual/TextAndWebiPhoneOS/CustomTextProcessing/CustomTextProcessing.html#//apple_ref/doc/uid/TP40009542-CH4-SW65)
with your custom fonts and styles (Interface Builder Compatible).


## Features

- [x] UIDynamicType with automatic updating
- [x] Custom user defined styles  
- [x] Interface Builder Support
- [ ] Objective-C Support (Not Tested)
- [ ] Attributed Text Support

## Requirements

- iOS 8.0+
- Xcode 7.2+

## Installation

### Carthage

[Install Carthage](https://github.com/Carthage/Carthage#installing-carthage)
and then add BadType to your `Cartfile`:
```
github "alvivi/BadType" "master"
```
After that follow the [standard instructions](https://github.com/Carthage/Carthage#adding-frameworks-to-an-application)
to add BadType to your project.

### Manually

**TODO**. But, you can follow any other [framework tutorial](https://github.com/Alamofire/Alamofire#embedded-framework)
changing references to BadType.

## Usage

### From source code

BadType adds extensions to UIKit components to enable the use of UIDynamicType
custom font styles. For example, you can change the style of `UILabel` to a
standard Headline style using:

```
myLabel.fontStyle = "Headline"
```

BadType will create a weak reference to that view to update the style if a
dynamic type notification is received. For creating custom font style see
[Custom Styles](https://github.com/alvivi/BadType#custom-styles) section.

### Interface Builder Support

**Note** that because an Interface Builder Bug ([rdar://23114017](https://openradar.appspot.com/23114017)),
the Interface Builder compatibility requires additional configuration.

BadType provides a family of components based UIKit ones that enable live view
into Interface Builder. These components are declared in [`BadType/BadType/BadTypeIBWorkaround.swift`](https://github.com/alvivi/BadType/blob/master/BadType/BadTypeIBWorkaround.swift).
To use them, first change the view's **custom class** attribute to their
corresponding BadType class (for example, from `UILabel` to `BTLabel`,
`UIButton` to `BTButton`, etc). Then set the **font style** attribute to
a name of a valid font style in your catalog (standard styles are `Headline`,
`Body`, `Footnote` and so on). The font style attribute is **case-sensitive**.

![](https://cloud.githubusercontent.com/assets/23727/12514991/5a59dab6-c126-11e5-8b16-45535eb86e81.png)

#### Enabling Interface Builder Support Using BadType as a Framework

To enable Interface Builder support you have to use a workaround. Frameworks do
not carry `@IBDesignable` and `@IBInspectable` information, so Interface Builder
does not see any custom views defined by BadType. To solve this problem, we have
two options: add BadType to your project as a target, or define in your project
all custom views. Here are the steps needed to use BadType as Framework and
Interface Builder Support.

  1. Add BadType framework to your project (either manually or with Carthage).
  2. Add [`BadType/BadType/BadTypeIBWorkaround.swift`](https://github.com/alvivi/BadType/blob/master/BadType/BadTypeIBWorkaround.swift)
     to your project. If you are using Carthage, you can add it from `Checkout`.
  3. For simple projects, IB should work now. If that is not your case and, you
     are probably getting errors about BadType framework not found by IB. Go
     to your target **Build Settings**, search for setting called **Runpath
     Search Paths** under **Linking** section and add the directory where
     BadType framework is located (something like `$(SRCROOT)/Carthage/Build` if
     you are using Carthage).

#### Enabling Interface Builder Support Using BadType as a Target

After embedding BadType in your project, just ensure that BadType Framework and
`BadType/BadType/BadTypeIBWorkaround.swift` match your target.

![ibmanual](https://cloud.githubusercontent.com/assets/23727/12516661/e4ff211e-c12e-11e5-98f3-7f83f2820042.png)


### Custom Styles

Custom styles are declared using a plist file named `FontStylesCatalog.plist`
that should be located in your target root folder. BadType comes with a standard
[catalog](https://github.com/alvivi/BadType/blob/master/BadType/FontStylesCatalog.plist)
which defines styles for `Body`, `Callout`, `Caption1`, `Caption2`, `Footnote`,
`Headline`, `Subheadline`, `Title1`, `Title2` and `Title3`. These styles can
be overridden by your styles. See the [example catalog](https://github.com/alvivi/BadType/blob/master/BadType-TestingApp-iOS/FontStylesCatalog.plist)
for more information.
