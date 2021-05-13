//
//  File.swift
//  
//
//  Created by Данил Войдилов on 13.05.2021.
//

import SwiftUI

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Font {
	
	public var providerType: FontProviderType? {
		Mirror(reflecting: self).descendant("provider", "base").flatMap { FontProviderType(value: $0) }
	}
	
	public var uiFont: UIFont? {
		providerType?.uiFont
	}
	
	public func size(_ size: CGFloat) -> Font {
		var provider = providerType
		provider?.size = size
		return provider?.font ?? self
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public indirect enum FontProviderType {
	case named(String, CGFloat, Font.TextStyle?)
	case style(Font.TextStyle, Font.Design, Font.Weight?)
	case platform(UIFont)
	case system(CGFloat, Font.Weight, Font.Design)
	case modifier(FontProviderType, FontModifierType)
	
	public var size: CGFloat? {
		get {
			switch self {
			case .named(_, let size, _):			return size
			case .style:											return nil
			case .system(let size, _, _):			return size
			case .modifier(let provider, _):	return provider.size
			case .platform(let font):					return font.pointSize
			}
		}
		set {
			guard let value = newValue else { return }
			switch self {
			case .named(let name, _, let style):
				self = .named(name, value, style)
			case .style:
				break
			case .system(_, let weight, let design):
				self = .system(value, weight, design)
			case .modifier(var provider, let modifier):
				provider.size = value
				self = .modifier(provider, modifier)
			case .platform(let font):
				self = .platform(font.withSize(value))
			}
		}
	}
	
	public var name: String? {
		switch self {
		case .named(let name, _, _):			return name
		case .style:											return nil
		case .system:											return nil
		case .modifier(let provider, _):	return provider.name
		case .platform(let font):					return font.fontName
		}
	}
	
	public var uiFont: UIFont? {
		switch self {
		case .named(let name, let size, let style):
			if let st = style, st != .body {
				return UIFont(name: name, size: size)?.withAttributes(
					[.textStyle: st.uiFontStyle]
				)
			} else {
				return UIFont(name: name, size: size)
			}
		case .style(let style, let design, let weight):
			var descriptor = UIFontDescriptor.preferredFontDescriptor(withTextStyle: style.uiFontStyle)
			descriptor = descriptor.withDesign(design.uiFontDesign) ?? descriptor
			if let w = weight {
				descriptor = descriptor.addingAttributes([.traits: [UIFontDescriptor.TraitKey.weight: w.uiFontWeight]])
			}
			return UIFont(descriptor: descriptor, size: UIFont.preferredFont(forTextStyle: style.uiFontStyle).pointSize)
		case .platform(let font): return font
		case .system(let size, let weight, let design):
			var descriptor = UIFont.systemFont(ofSize: size, weight: weight.uiFontWeight).fontDescriptor
			descriptor = descriptor.withDesign(design.uiFontDesign) ?? descriptor
			return UIFont(descriptor: descriptor, size: size)
		case .modifier(let provider, let modifier):
			switch modifier {
			case .bold:									return provider.uiFont?.withTraits(.traitBold)
			case .italic:								return provider.uiFont?.withTraits(.traitItalic)
			case .monospacedDigit:
				return provider.uiFont?.withAttributes(
					[
						.featureSettings: [[
							UIFontDescriptor.FeatureKey.featureIdentifier: kNumberSpacingType,
							UIFontDescriptor.FeatureKey.typeIdentifier: kMonospacedNumbersSelector
						]]
					]
				)
			case .lowercaseSmallCaps:
				return provider.uiFont?.withAttributes(
					[
						.featureSettings: [[
							UIFontDescriptor.FeatureKey.featureIdentifier: kLowerCaseType,
							UIFontDescriptor.FeatureKey.typeIdentifier: kLowerCaseSmallCapsSelector
						]]
					]
				)
			case .smallCaps:
				return provider.uiFont?.withAttributes(
					[
						.featureSettings: [
							[
								UIFontDescriptor.FeatureKey.featureIdentifier: kUpperCaseType,
								UIFontDescriptor.FeatureKey.typeIdentifier: kSmallCapsSelector
							], [
								UIFontDescriptor.FeatureKey.featureIdentifier: kLowerCaseType,
								UIFontDescriptor.FeatureKey.typeIdentifier: kLowerCaseSmallCapsSelector
							]
						]
					]
				)
			case .uppercaseSmallCaps:
				return provider.uiFont?.withAttributes(
					[
						.featureSettings: [[
							UIFontDescriptor.FeatureKey.featureIdentifier: kUpperCaseType,
							UIFontDescriptor.FeatureKey.typeIdentifier: kSmallCapsSelector
						]]
					]
				)
			case .weight(let weight):	return provider.uiFont?.withAttributes(
				[.traits: [UIFontDescriptor.TraitKey.weight: weight.uiFontWeight]]
			)
			
			case .leading(let leading):
				if #available(iOS 14.0, *) {
					switch leading {
					case .loose:	return provider.uiFont?.withTraits(.traitLooseLeading)
					default:			return provider.uiFont?.withTraits(.traitTightLeading)
					}
				} else {
					return provider.uiFont
				}
			}
		}
	}
	
	public var font: Font {
		switch self {
		case .named(let name, let size, let style):
			switch style {
			case .body:
				return .custom(name, size: size)
			case .none:
				if #available(iOS 14.0, *) {
					return .custom(name, fixedSize: size)
				} else {
					return .custom(name, size: size)
				}
			default:
				if #available(iOS 14.0, *) {
					return .custom(name, size: size, relativeTo: style ?? .body)
				} else {
					return .custom(name, size: size)
				}
			}
		case .style(let style, let design, let weight):
			if let w = weight {
				return .system(style, design: design).weight(w)
			} else {
				return .system(style, design: design)
			}
		case .system(let size, let weight, let design):
			return .system(size: size, weight: weight, design: design)
		case .modifier(let provider, let modifier):
			switch modifier {
			case .bold:									return provider.font.bold()
			case .italic:								return provider.font.italic()
			case .monospacedDigit:			return provider.font.monospacedDigit()
			case .lowercaseSmallCaps:		return provider.font.lowercaseSmallCaps()
			case .smallCaps:						return provider.font.smallCaps()
			case .uppercaseSmallCaps:		return provider.font.uppercaseSmallCaps()
			case .weight(let weight):		return provider.font.weight(weight)
			case .leading(let leading):
				if #available(iOS 14.0, *) {
					return provider.font.leading(leading)
				} else {
					return .body
				}
			}
		case .platform(let font):	return Font(font)
		}
	}
	
	init?(value: Any) {
		let typeString = "\(type(of: value))"
		let children = Mirror(reflecting: value).dictionary
		switch typeString {
		case "SystemProvider":
			guard let size = children["size"] as? CGFloat,
						let weight = children["weight"] as? Font.Weight,
						let design = children["design"] as? Font.Design else {
				return nil
			}
			self = .system(size, weight, design)
		case "TextStyleProvider":
			guard let style = children["style"] as? Font.TextStyle,
						let design = children["design"] as? Font.Design else {
				return nil
			}
			let weight = children["weight"] as? Font.Weight
			self = .style(style, design, weight)
		case "NamedProvider":
			guard let size = children["size"] as? CGFloat,
						let name = children["name"] as? String else {
				return nil
			}
			let style = children["textStyle"] as? Font.TextStyle
			self = .named(name, size, style)
		case "PlatformFontProvider":
			guard let font = children["font"] as? UIFont else {
				return nil
			}
			self = .platform(font)
		default:
			if typeString.hasPrefix("Modifier"),
				 let base = (children["base"] as? Font)?.providerType,
				 let modifier = children["modifier"].flatMap({ FontModifierType(value: $0) }) {
				self = .modifier(base, modifier)
			} else {
				return nil
			}
		}
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
public enum FontModifierType {
	case bold, italic, monospacedDigit, lowercaseSmallCaps, smallCaps, uppercaseSmallCaps, weight(Font.Weight)
	@available(iOS 14.0, *)
	case leading(Font.Leading)
	
	init?(value: Any) {
		let typeString = "\(type(of: value))"
		switch typeString {
		case "BoldModifier": 								self = .bold
		case "ItalicModifier": 							self = .italic
		case "MonospacedDigitModifier": 		self = .monospacedDigit
		case "LowercaseSmallCapsModifier": 	self = .lowercaseSmallCaps
		case "SmallCapsModifier": 					self = .smallCaps
		case "UppercaseSmallCapsModifier": 	self = .uppercaseSmallCaps
		case "WeightModifier":
			if let weight = Mirror(reflecting: value).children.first?.value as? Font.Weight {
				self = .weight(weight)
			} else {
				return nil
			}
		case "LeadingModifier":
			if #available(iOS 14.0, *) {
				if let leading =  Mirror(reflecting: value).children.first?.value as? Font.Leading {
					self = .leading(leading)
				} else {
					return nil
				}
			} else {
				return nil
			}
		default:	return nil
		}
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Font.TextStyle {
	public var uiFontStyle: UIFont.TextStyle {
		switch self {
		case .largeTitle:		return .largeTitle
		case .title:				return .title1
		case .title2:				return .title2
		case .title3:				return .title3
		case .headline:			return .headline
		case .subheadline:	return .subheadline
		case .body:					return .body
		case .callout:			return .callout
		case .footnote:			return .footnote
		case .caption:			return .caption1
		case .caption2:			return .caption2
		@unknown default:		return .body
		}
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Font.Weight {
	public var uiFontWeight: UIFont.Weight {
		(Mirror(reflecting: self).children.first?.value as? CGFloat).map {
			UIFont.Weight($0)
		} ?? .regular
	}
}

@available(iOS 13.0, OSX 10.15, tvOS 13.0, watchOS 6.0, *)
extension Font.Design {
	public var uiFontDesign: UIFontDescriptor.SystemDesign {
		switch self {
		case .default:		return .default
		case .serif:			return .serif
		case .rounded:		return .rounded
		case .monospaced:	return .monospaced
		@unknown default:	return .default
		}
	}
}

extension UIFont {
	
	public func withTraits(_ traits: UIFontDescriptor.SymbolicTraits...) -> UIFont {
		guard let descriptor = fontDescriptor.withSymbolicTraits(UIFontDescriptor.SymbolicTraits(traits)) else {
			return self
		}
		return UIFont(descriptor: descriptor, size: pointSize)
	}
	
	public func withAttributes(_ attributes: [UIFontDescriptor.AttributeName: Any]) -> UIFont {
		UIFont(descriptor: fontDescriptor.addingAttributes(attributes), size: pointSize)
	}
	
	public var italic: UIFont {
		return withTraits(.traitItalic)
	}
	
	public var bold: UIFont {
		return withTraits(.traitBold)
	}
}
