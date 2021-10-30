//
//  UIColor++.swift
//  UIKitExtensions
//
//  Created by Daniil on 10.08.2019.
//

#if canImport(UIKit)
import UIKit

infix operator |: AdditionPrecedence

extension UIColor {
  
  public convenience init(_ rgb: UInt) {
    self.init(
      red: CGFloat((rgb & 0xFF0000) >> 16) / 255.0,
      green: CGFloat((rgb & 0x00FF00) >> 8) / 255.0,
      blue: CGFloat(rgb & 0x0000FF) / 255.0,
      alpha: CGFloat(1.0)
    )
  }
  
  public convenience init(_ colors: UIColor...) {
    guard !colors.isEmpty else {
      self.init(red: 0, green: 0, blue: 0, alpha: 0)
      return
    }
    let components: RGBA = colors.map { $0.rgba }.reduce((0, 0, 0, 0), +)
    let cnt = CGFloat(colors.count)
    self.init(red: components.0 / cnt, green: components.1 / cnt, blue: components.2 / cnt, alpha: components.3 / cnt)
  }
  
  public convenience init(_ color1: UIColor, _ color2: UIColor, k: CGFloat) {
    let (r1, g1, b1, a1) = color1.rgba
    let (r2, g2, b2, a2) = color2.rgba
    self.init(
      red: (r2 - r1) * k + r1,
      green: (g2 - g1) * k + g1,
      blue: (b2 - b1) * k + b1,
      alpha: (a2 - a1) * k + a1
    )
  }
  
  public convenience init?(hex: String) {
    guard let (red, green, blue, alpha) = UIColor.rgba(hex: hex) else {
      return nil
    }
    self.init(red: red, green: green, blue: blue, alpha: alpha)
  }
  
  private static func rgba(hex: String) -> (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)? {
    let input = hex.replacingOccurrences(of: "#", with: "").uppercased()
    var alpha: CGFloat = 1.0
    var red: CGFloat = 0
    var blue: CGFloat = 0
    var green: CGFloat = 0
    switch (input.count) {
    case 3 /* #RGB */:
      red = Self.colorComponent(from: input, start: 0, length: 1)
      green = Self.colorComponent(from: input, start: 1, length: 1)
      blue = Self.colorComponent(from: input, start: 2, length: 1)
    case 4 /* #RGBA */:
      red = Self.colorComponent(from: input, start: 0, length: 1)
      green = Self.colorComponent(from: input, start: 1, length: 1)
      blue = Self.colorComponent(from: input, start: 2, length: 1)
      alpha = Self.colorComponent(from: input, start: 3, length: 1)
    case 6 /* #RRGGBB */:
      red = Self.colorComponent(from: input, start: 0, length: 2)
      green = Self.colorComponent(from: input, start: 2, length: 2)
      blue = Self.colorComponent(from: input, start: 4, length: 2)
    case 8 /* #RRGGBBAA */:
      red = Self.colorComponent(from: input, start: 0, length: 2)
      green = Self.colorComponent(from: input, start: 2, length: 2)
      blue = Self.colorComponent(from: input, start: 4, length: 2)
      alpha = Self.colorComponent(from: input, start: 6, length: 2)
    default:
      return nil
    }
    return (red, green, blue, alpha)
  }
  
  private static func colorComponent(from string: String, start: Int, length: Int) -> CGFloat {
    let substring = (string as NSString).substring(with: NSRange(location: start, length: length))
    let fullHex = length == 2 ? substring : "\(substring)\(substring)"
    var hexComponent: UInt64 = 0
    Scanner(string: fullHex).scanHexInt64(&hexComponent)
    return CGFloat(Double(hexComponent) / 255.0)
  }
  
  public var red: CGFloat { rgba.red }
  public var green: CGFloat { rgba.green }
  public var blue: CGFloat { rgba.blue }
  
  public var hue: CGFloat { hsba.hue }
  public var saturation: CGFloat { hsba.saturation }
  public var brightness: CGFloat { hsba.brightness }
  
  public var alpha: CGFloat { rgba.alpha }
  
  public var hex: String { hex(hideAlpha: false) }
  
  public func hex(hideAlpha: Bool) -> String {
    let (r, g, b, a) = rgba
    
    let multiplier = CGFloat(255.999999)
    
    if a == 1 || hideAlpha {
      return String(
        format: "#%02lX%02lX%02lX",
        Int(r * multiplier),
        Int(g * multiplier),
        Int(b * multiplier)
      )
    } else {
      return String(
        format: "#%02lX%02lX%02lX%02lX",
        Int(r * multiplier),
        Int(g * multiplier),
        Int(b * multiplier),
        Int(a * multiplier)
      )
    }
  }
  
  public var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
    var red: CGFloat = 0
    var green: CGFloat = 0
    var blue: CGFloat = 0
    var alpha: CGFloat = 0
    getRed(&red, green: &green, blue: &blue, alpha: &alpha)
    return (red, green, blue, alpha)
  }
  
  public var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
    var hue: CGFloat = 0
    var saturation: CGFloat = 0
    var brightness: CGFloat = 0
    var alpha: CGFloat = 0
    getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
    return (hue, saturation, brightness, alpha)
  }
  
  @inlinable
  public func alpha(_ alpha: CGFloat) -> UIColor {
    withAlphaComponent(alpha)
  }
  
  public func red(_ red: CGFloat) -> UIColor {
    let (_, green, blue, alpha) = rgba
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }
  
  public func green(_ green: CGFloat) -> UIColor {
    let (red, _, blue, alpha) = rgba
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }
  
  public func blue(_ blue: CGFloat) -> UIColor {
    let (red, green, _, alpha) = rgba
    return UIColor(red: red, green: green, blue: blue, alpha: alpha)
  }
  
  public func hue(_ hue: CGFloat) -> UIColor {
    let (_, saturation, brightness, alpha) = hsba
    return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
  }
  
  public func saturation(_ saturation: CGFloat) -> UIColor {
    let (hue, _, brightness, alpha) = hsba
    return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
  }
  
  public func brightness(_ brightness: CGFloat) -> UIColor {
    let (hue, saturation, _, alpha) = hsba
    return UIColor(hue: hue, saturation: saturation, brightness: brightness, alpha: alpha)
  }
  
  public func backgound(_ color: UIColor) -> UIColor {
    let topRGBA = rgba
    let bottomRGBA = color.rgba
    let alpha = (1 - topRGBA.alpha) * bottomRGBA.alpha + topRGBA.alpha
    guard alpha > 0 else {
      return UIColor(
        red: (topRGBA.red - bottomRGBA.red) / 2 + bottomRGBA.red,
        green: (topRGBA.green - bottomRGBA.green) / 2 + bottomRGBA.green,
        blue: (topRGBA.blue - bottomRGBA.blue) / 2 + bottomRGBA.blue,
        alpha: 0
      )
    }
    
    return UIColor(
      red: ((1 - topRGBA.alpha) * bottomRGBA.alpha * bottomRGBA.red + topRGBA.alpha * topRGBA.red) / alpha,
      green: ((1 - topRGBA.alpha) * bottomRGBA.alpha * bottomRGBA.green + topRGBA.alpha * topRGBA.green) / alpha,
      blue: ((1 - topRGBA.alpha) * bottomRGBA.alpha * bottomRGBA.blue + topRGBA.alpha * topRGBA.blue) / alpha,
      alpha: alpha
    )
  }
  
  public func overlay(_ color: UIColor) -> UIColor {
    color.backgound(self)
  }
  
  public static func | (lightMode: UIColor, darkMode: UIColor) -> UIColor {
    guard #available(iOS 13.0, *) else { return lightMode }
    
    return UIColor { (traitCollection) -> UIColor in
      return traitCollection.userInterfaceStyle == .light ? lightMode : darkMode
    }
  }
  
  public static func +(_ lhs: UIColor, _ rhs: UIColor) -> UIColor {
    UIColor(lhs, rhs, k: 0.5)
  }
  
//  public static func -(_ left: UIColor, _ right: UIColor) -> UIColor {
//    let leftRGBA = left.rgba
//    let rightRGBA = right.rgba
//
//    let red = min(max(leftRGBA.red - rightRGBA.red, 0.0), 1.0)
//    let green = min(max(leftRGBA.green - rightRGBA.green, 0.0), 1.0)
//    let blue = min(max(leftRGBA.blue - rightRGBA.blue, 0.0), 1.0)
//
//    let sum = (leftRGBA.red + leftRGBA.green + leftRGBA.blue)
//    guard sum > 0 else {
//      return UIColor.black.withAlphaComponent(<#T##alpha: CGFloat##CGFloat#>)
//    }
//
//    return UIColor(
//      red: red,
//      green: green,
//      blue: blue,
//      alpha: leftRGBA.alpha * (red + green + blue) / (leftRGBA.red + leftRGBA.green + leftRGBA.blue)
//    )
//  }
}

extension Decodable where Self: UIColor {
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let hex = try container.decode(String.self)
    guard let color = UIColor(hex: hex) else {
      throw DecodingError.dataCorruptedError(in: container, debugDescription:  "Color value \"\(hex)\" is invalid. It should be a hex value of the form #RBG, #RGBA, #RRGGBB, or #RRGGBBAA")
    }
    guard let it = color as? Self else {
      throw DecodingError.dataCorruptedError(in: container, debugDescription: "UIColor subclass cannot be decoded")
    }
    self = it
  }
}

extension UIColor: Decodable {}

extension Encodable where Self: UIColor {
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(hex)
  }
}

extension UIColor: Encodable {}

fileprivate typealias RGBA = (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat)

fileprivate func +(_ lhs: RGBA, _ rhs: RGBA) -> RGBA {
  return (lhs.0 + rhs.0, lhs.1 + rhs.1, lhs.2 + rhs.2, lhs.3 + rhs.3)
}

extension CGColorSpace {
  
  public static var p3: CGColorSpace? {
    CGColorSpace(name: CGColorSpace.displayP3)
  }
}

extension UIImage {
  
  public func tinted(with color: UIColor) -> UIImage {
    var image = withRenderingMode(.alwaysTemplate)
    UIGraphicsBeginImageContextWithOptions(size, false, scale)
    color.set()
    image.draw(in: CGRect(origin: .zero, size: size))
    image = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
  }
  
  public convenience init?(color: UIColor, size: CGSize = CGSize(width: 1, height: 1)) {
    UIGraphicsBeginImageContextWithOptions(size, false, 0)
    color.setFill()
    UIRectFill(CGRect(origin: .zero, size: size))
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    guard let cgImage = image?.cgImage else {
      return nil
    }
    self.init(cgImage: cgImage)
  }
}
#endif
