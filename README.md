# VDKit

[![CI Status](https://img.shields.io/travis/dankinsoid/VD.svg?style=flat)](https://travis-ci.org/dankinsoid/VD)
[![Version](https://img.shields.io/cocoapods/v/VD.svg?style=flat)](https://cocoapods.org/pods/VD)
[![License](https://img.shields.io/cocoapods/l/VD.svg?style=flat)](https://cocoapods.org/pods/VD)
[![Platform](https://img.shields.io/cocoapods/p/VD.svg?style=flat)](https://cocoapods.org/pods/VD)

## Description
This repository contains useful extensions on Foundation, UIKit and SwiftUI

## Usage
### VDChain
Combination of [`@dynamicMemberLookup`](https://docs.swift.org/swift-book/ReferenceManual/Attributes.html) with `KeyPath`es and `callAsFunction`
```swift
let label = UILabel()~
  .text("Text")
  .textColor(.red)
  .font(.system(24))
  .apply()
```
### VDDates
`Date` struct provides very little functionality, any operations with dates must be implemented through `Calendar` in very unintuitive, complex and difficult to remember ways.
To simplify operations with dates, this library provides a simple and intuitive syntax.

#### Some examples
```swift
let afterTomorrow: Date = .today + 2.days
//or .today + .days(2)
//or Date.today.adding(2 * .day)
let difference = date2 - date1
let daysBetweenDates = difference.days
//or date2.interval(of: .day, from: date1)
let weeksBetweenDates = difference.weeks
```
```swift
let hours = Date().component(.hour)
//or Date().hour()
let someDate = Date(year: 1994, month: 10, day: 4) 
```
```swift
let startOfMonth = Date().start(of: .month)
let lastMonth = Date().end(of: .year)
let lastDay = Date().end(of: .year, accuracy: .day)
let nextYear = Date().next(.year)
let nextLeapYear = Date().nearest([.month: 2, .day: 29], in: .future)?.start(of: .year)
```
```swift
let monthLenght = Date().count(of: .day, in: .month)
for month in (date1...date2).each(.month) {...}
```
```swift
let weekdayName = Date().name(of: .weekday)
if let date = Date(from: dateString, format: "dd.MM.yyyy") {...}
let dateString = Date().string("dd.MM.yyyy")
let iso860String = Date().iso860
let defaultDateString = Date().string(date: .long, time: .short)
let relativeDateString = Date().string("dd.MM.yyyy",
                            relative: [
                                .day(1): "Tomorrow",
                                .day(0): "Today, HH:mm",
                                .day(-1): "Yesterday",
                                .week(0): "EEEE",       
                                .year(0): "dd.MM"
                            ]
                        )
```
Any function contains additional parameters with default values such as: 
```swift
calendar: Calendar = .default
locale: Locale = .default
timezone: TimeZone = .default
```
where `Calendar.default`, `Locale.default` and `TimeZone.default` - static variables that you can change.
So you can use custom `Calendar` in each function
```swift
let dayOfMonth = Date().position(of: .day, in: .month, calendar: customCalendar)
```
Or you can set your own `default` value for all functions
```swift
Calendar.default = customCalendar
```
### VDBuilders
- `ArrayBuilder<T>` - result builder to create arrays
- `ComposeBuilder`
- `SingleBuilder`

### UIKitIntegration
Easy integration `UIKit` elements to `SwiftUI` code.
This realization uses `@autoclosure`s in order to avoid `UIView` re-creation. `§` operator creates `UIKitView`, `UIKitView` supports [chaining](https://github.com/dankinsoid/VDKit/blob/master/README.md#vdchain) to update `UIView`. `.uiKitViewEnvironment` modifier allows to set `UIView`s properties as environments via chaining.
```swift
@State var text: String 
let textColor: Color 

var body: some View {
  VStack {
    Text(text)
      .foregroundColor(textColor)
  
    UILabel()§
      .text(text)
      .contentPriority.horizontal.compression(.required)
    
    UIKitView {
      UILabel()
    } update: { label, context in
      label.text = text
    }
    
    UIImageView()
  }
  .uiKitViewEnvironment(for: UILabel.self)
  .textColor(textColor.ui)
  .tintColor(.red)
}
```
### VDLayout
`SwiftUI` like syntaxis for `UIKit` via function builders and [`chaining`](https://github.com/dankinsoid/VDKit/blob/master/README.md#vdchain)
```swift
class YourView: LtView {

  @SubviewsBuilder
  override func layout() -> [SubviewProtocol] {
    UIStackView(.vertical) { 
      UILabel()~
        .textColor(.black)
        .font(.systemFont(ofSize: 20))

      someView { 
        someImageView~
          .image(someImage)
      }

      Text("SubviewsBuilder supports SwiftUI views too")
    }
  }
}
```
`VDLayout` is good for use with [`ConstraintsOperators`](https://github.com/dankinsoid/ConstraintsOperators), just need make `Constraints<Item>` impelemts `SubviewProtocol` 
```swift
UIView { 
  label
    .height(30)
    .width(someView.width / 2 + 10)
    .centerX(0)
    .edges(.vertical).equal(to: 10)
}
```
### UIKitEnvironment
```swift
view.environments.someValue = 0

extension UIViewEnvironment {
  var someValue: Int {
    get { self[\.someValue] ?? 0 }
    set { self[\.someValue] = newValue }
  }
}
```

## Installation
1.  [Swift Package Manager](https://github.com/apple/swift-package-manager)

Create a `Package.swift` file.
```swift
// swift-tools-version:5.0
import PackageDescription

let package = Package(
  name: "SomeProject",
  dependencies: [
    .package(url: "https://github.com/dankinsoid/VDKit.git", from: "1.127.0")
  ],
  targets: [
    .target(name: "SomeProject", dependencies: ["VDKit"])
  ]
)
```
```ruby
$ swift build
```

## Author

dankinsoid, voidilov@gmail.com

## License

VDAnimation is available under the MIT license. See the LICENSE file for more info.
