//
//  File.swift
//  
//
//  Created by Данил Войдилов on 13.05.2021.
//

#if canImport(SwiftUI)
import SwiftUI
#if canImport(UIKit)
import UIKit
#elseif canImport(AppKit)
import AppKit
#endif

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color: _ExpressibleByColorLiteral {
	
	public init(_colorLiteralRed red: Float, green: Float, blue: Float, alpha: Float) {
    self = Color(.sRGB, red: Double(red), green: Double(green), blue: Double(blue), opacity: Double(alpha))
	}
	
#if canImport(UIKit)
	public var ui: UIColor {
		get {
			if #available(iOS 14.0, *) {
				return UIColor(self)
			} else {
				if self == .clear { return .clear }
				let (r, g, b, a) = _rgba
				return UIColor(red: r, green: g, blue: b, alpha: a)
			}
		}
		set {
			self = Color(newValue)
		}
	}
#elseif canImport(AppKit)
	public var ns: NSColor {
		if #available(macOS 11.0, *) {
			return NSColor(self)
		} else {
			if self == .clear { return .clear }
			let (r, g, b, a) = _rgba
			return NSColor(red: r, green: g, blue: b, alpha: a)
		}
	}
#endif
	
	private var _rgba: (r: CGFloat, g: CGFloat, b: CGFloat, a: CGFloat) {
		let scanner = Scanner(string: self.description.trimmingCharacters(in: CharacterSet.alphanumerics.inverted))
		var hexNumber: UInt64 = 0
		var (r, g, b, a): (CGFloat, CGFloat, CGFloat, CGFloat) = (0, 0, 0, 0)
		
		let result = scanner.scanHexInt64(&hexNumber)
		if result {
			r = CGFloat((hexNumber & 0xff000000) >> 24) / 255
			g = CGFloat((hexNumber & 0x00ff0000) >> 16) / 255
			b = CGFloat((hexNumber & 0x0000ff00) >> 8) / 255
			a = CGFloat(hexNumber & 0x000000ff) / 255
		}
		return (r, g, b, a)
	}
  
  public init(_ rgb: UInt) {
    self = Color(
      red: Double((rgb & 0xFF0000) >> 16) / 255.0,
      green: Double((rgb & 0x00FF00) >> 8) / 255.0,
      blue: Double(rgb & 0x0000FF) / 255.0,
      opacity: Double(1.0)
    )
  }
  
  public init(_ colors: Color...) {
    guard !colors.isEmpty else {
      self = Color(red: 0, green: 0, blue: 0, opacity: 0)
      return
    }
    let components: RGBA = colors.map { $0.rgba }.reduce((0, 0, 0, 0), +)
    let cnt = Double(colors.count)
    self.init(red: components.0 / cnt, green: components.1 / cnt, blue: components.2 / cnt, opacity: components.3 / cnt)
  }
  
  public init(_ color1: Color, _ color2: Color, k: Double) {
    let (r1, g1, b1, a1) = color1.rgba
    let (r2, g2, b2, a2) = color2.rgba
    self = Color(
      red: (r2 - r1) * k + r1,
      green: (g2 - g1) * k + g1,
      blue: (b2 - b1) * k + b1,
      opacity: (a2 - a1) * k + a1
    )
  }
  
  public init?(hex: String) {
    let input = hex.replacingOccurrences(of: "#", with: "").uppercased()
    var alpha: Double = 1.0
    var red: Double = 0
    var blue: Double = 0
    var green: Double = 0
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
    self = Color(red: red, green: green, blue: blue, opacity: alpha)
  }
  
  private static func colorComponent(from string: String, start: Int, length: Int) -> Double {
    let substring = (string as NSString).substring(with: NSRange(location: start, length: length))
    let fullHex = length == 2 ? substring : "\(substring)\(substring)"
    var hexComponent: UInt64 = 0
    Scanner(string: fullHex).scanHexInt64(&hexComponent)
    return Double(hexComponent) / 255.0
  }
  
	public var red: Double { get { rgba.red } set { rgba.red = newValue } }
	public var green: Double { get { rgba.green } set { rgba.green = newValue } }
	public var blue: Double { get { rgba.blue } set { rgba.blue = newValue } }
  
	public var hue: Double { get { hsba.hue } set { hsba.hue = newValue } }
	public var saturation: Double { get { hsba.saturation } set { hsba.saturation = newValue } }
	public var brightness: Double { get { hsba.brightness } set { hsba.brightness = newValue } }
  
  public var opacity: Double {
		get { rgba.opacity }
		set { self = self.opacity(newValue) }
	}
	
  public var hex: String { hex(hideOpacity: false) }
  
  public func hex(hideOpacity: Bool) -> String {
    let (r, g, b, a) = rgba
    
    let multiplier = Double(255.999999)
    
    if a == 1 || hideOpacity {
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
	
	public var rgba: (red: Double, green: Double, blue: Double, opacity: Double) {
		get {
#if canImport(UIKit)
			let (r, g, b, a) = ui.rgba
#elseif canImport(AppKit)
			let (r, g, b, a) = ns.rgba
#endif
			return (Double(r), Double(g), Double(b), Double(a))
		}
		set {
			self = Color(.sRGB, red: newValue.red, green: newValue.green, blue: newValue.blue, opacity: newValue.opacity)
		}
	}
  
  public var hsba: (hue: Double, saturation: Double, brightness: Double, opacity: Double) {
		get {
#if canImport(UIKit)
			let (h, s, b, a) = ui.hsba
#elseif canImport(AppKit)
			let (h, s, b, a) = ns.hsba
#endif
			return (Double(h), Double(s), Double(b), Double(a))
		}
		set {
			self = Color(hue: newValue.hue, saturation: newValue.saturation, brightness: newValue.saturation, opacity: newValue.opacity)
		}
  }
  
  public func red(_ red: Double) -> Color {
    let (_, green, blue, opacity) = rgba
    return Color(red: red, green: green, blue: blue, opacity: opacity)
  }
  
  public func green(_ green: Double) -> Color {
    let (red, _, blue, opacity) = rgba
    return Color(red: red, green: green, blue: blue, opacity: opacity)
  }
  
  public func blue(_ blue: Double) -> Color {
    let (red, green, _, opacity) = rgba
    return Color(red: red, green: green, blue: blue, opacity: opacity)
  }
  
  public func hue(_ hue: Double) -> Color {
    let (_, saturation, brightness, opacity) = hsba
    return Color(hue: hue, saturation: saturation, brightness: brightness, opacity: opacity)
  }
  
  public func saturation(_ saturation: Double) -> Color {
    let (hue, _, brightness, opacity) = hsba
    return Color(hue: hue, saturation: saturation, brightness: brightness, opacity: opacity)
  }
  
  public func brightness(_ brightness: Double) -> Color {
    let (hue, saturation, _, opacity) = hsba
    return Color(hue: hue, saturation: saturation, brightness: brightness, opacity: opacity)
  }
  
  public func backgound(_ color: Color) -> Color {
    let topRGBA = rgba
    let bottomRGBA = color.rgba
    let alpha = (1 - topRGBA.opacity) * bottomRGBA.opacity + topRGBA.opacity
    guard alpha > 0 else {
      return Color(
        red: (topRGBA.red - bottomRGBA.red) / 2 + bottomRGBA.red,
        green: (topRGBA.green - bottomRGBA.green) / 2 + bottomRGBA.green,
        blue: (topRGBA.blue - bottomRGBA.blue) / 2 + bottomRGBA.blue,
        opacity: 0
      )
    }
    
    return Color(
      red: ((1 - topRGBA.opacity) * bottomRGBA.opacity * bottomRGBA.red + topRGBA.opacity * topRGBA.red) / alpha,
      green: ((1 - topRGBA.opacity) * bottomRGBA.opacity * bottomRGBA.green + topRGBA.opacity * topRGBA.green) / alpha,
      blue: ((1 - topRGBA.opacity) * bottomRGBA.opacity * bottomRGBA.blue + topRGBA.opacity * topRGBA.blue) / alpha,
      opacity: alpha
    )
  }
  
  public func overlay(_ color: Color) -> Color {
    color.backgound(self)
  }
  
  public static func +(_ lhs: Color, _ rhs: Color) -> Color {
    Color(lhs, rhs, k: 0.5)
  }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color: Decodable {
  
  public init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    let hex = try container.decode(String.self)
    guard let color = Color(hex: hex) else {
      throw DecodingError.dataCorruptedError(in: container, debugDescription:  "Color value \"\(hex)\" is invalid. It should be a hex value of the form #RBG, #RGBA, #RRGGBB, or #RRGGBBAA")
    }
    self = color
  }
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Color: Encodable {
  
  public func encode(to encoder: Encoder) throws {
    var container = encoder.singleValueContainer()
    try container.encode(hex)
  }
}

fileprivate typealias RGBA = (red: Double, green: Double, blue: Double, opacity: Double)

fileprivate func +(_ lhs: RGBA, _ rhs: RGBA) -> RGBA {
  return (lhs.0 + rhs.0, lhs.1 + rhs.1, lhs.2 + rhs.2, lhs.3 + rhs.3)
}

#if canImport(UIKit)
fileprivate extension UIColor {
	
	var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
		var red: CGFloat = 0
		var green: CGFloat = 0
		var blue: CGFloat = 0
		var alpha: CGFloat = 0
		getRed(&red, green: &green, blue: &blue, alpha: &alpha)
		return (red, green, blue, alpha)
	}
	
	var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
		var hue: CGFloat = 0
		var saturation: CGFloat = 0
		var brightness: CGFloat = 0
		var alpha: CGFloat = 0
		getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
		return (hue, saturation, brightness, alpha)
	}
}
#elseif canImport(AppKit)
fileprivate extension NSColor {
	
	var rgba: (red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
		let ciColor: CIColor = CIColor(color: self) ?? CIColor()
		return (ciColor.red, ciColor.green, ciColor.blue, ciColor.alpha)
	}
	
	var hsba: (hue: CGFloat, saturation: CGFloat, brightness: CGFloat, alpha: CGFloat) {
		var hue: CGFloat = 0
		self.getHue(nil, saturation: nil, brightness: nil, alpha: nil)
		var saturation: CGFloat = 0
		var brightness: CGFloat = 0
		var alpha: CGFloat = 0
		getHue(&hue, saturation: &saturation, brightness: &brightness, alpha: &alpha)
		return (hue, saturation, brightness, alpha)
	}
}
#endif
#endif
