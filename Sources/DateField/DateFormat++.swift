//
//  DateFormat++.swift
//  DateField
//
//  Created by Данил Войдилов on 27.01.2022.
//

#if canImport(UIKit)
import Foundation
import VDDates

extension DateFormat.Element {
	
	var defaultStyle: UIDateField.ComponentStyle {
		switch format {
		case "a": return .init(keyboard: .default, empty: "--")
		case "G": return .init(keyboard: .default, empty: "--")
		case "GGG": return .init(keyboard: .default, empty: "----")
		case "GGGG": return .init(keyboard: .default, empty: "-")
		case "yy": return .init(keyboard: .numberPad, empty: "--")
		case "y": return .init(keyboard: .numberPad, empty: "----")
		case "yyyy": return .init(keyboard: .numberPad, empty: "----")
		case "M": return .init(keyboard: .numberPad, empty: "--")
		case "MM": return .init(keyboard: .numberPad, empty: "--")
		case "MMM": return .init(keyboard: .default, empty: "---")
		case "MMMM": return .init(keyboard: .default, empty: "-")
		case "MMMMM": return .init(keyboard: .default, empty: "-")
		case "d": return .init(keyboard: .numberPad, empty: "--")
		case "dd": return .init(keyboard: .numberPad, empty: "--")
		case "h": return .init(keyboard: .numberPad, empty: "--")
		case "hh": return .init(keyboard: .numberPad, empty: "--")
		case "H": return .init(keyboard: .numberPad, empty: "--")
		case "HH": return .init(keyboard: .numberPad, empty: "--")
		case "m": return .init(keyboard: .numberPad, empty: "--")
		case "mm": return .init(keyboard: .numberPad, empty: "--")
		case "s": return .init(keyboard: .numberPad, empty: "--")
		case "ss": return .init(keyboard: .numberPad, empty: "--")
		case "E": return .init(keyboard: .default, empty: "---")
		case "EEEE": return .init(keyboard: .default, empty: "-")
		case "EEEEE": return .init(keyboard: .default, empty: "-")
		case "Q": return .init(keyboard: .numberPad, empty: "-")
		case "QQQ": return .init(keyboard: .default, empty: "--")
		case "QQQQ": return .init(keyboard: .default, empty: "-")
		case "W": return .init(keyboard: .numberPad, empty: "-")
		case "w": return .init(keyboard: .numberPad, empty: "--")
		case "ww": return .init(keyboard: .numberPad, empty: "--")
		case "YY": return .init(keyboard: .numberPad, empty: "--")
		case "Y": return .init(keyboard: .numberPad, empty: "----")
		case "YYYY": return .init(keyboard: .numberPad, empty: "----")
		case "SSS": return .init(keyboard: .numberPad, empty: "---")
		case "SSSS": return .init(keyboard: .numberPad, empty: "----")
		case "Z": return .init(keyboard: .numberPad, empty: "-----")
		case "zzzz": return .init(keyboard: .default, empty: "---------")
		case "ZZZZZ": return .init(keyboard: .default, empty: "------")
		case "zzz": return .init(keyboard: .default, empty: "------")
		default: return .init(keyboard: .default)
		}
	}
	
	var maxLenght: Int? {
		switch self {
		case .string(let string):
			return string.count
		case .custom:
			return nil
		default:
			switch format {
			case "a": return 2
			case "G": return 2
			case "GGG": return 2
			case "GGGG": return nil
			case "yy": return 2
			case "y": return 4
			case "yyyy": return 4
			case "M": return 2
			case "MM": return 2
			case "MMM": return 3
			case "MMMM": return nil
			case "MMMMM": return nil
			case "d": return 2
			case "dd": return 2
			case "h": return 2
			case "hh": return 2
			case "H": return 2
			case "HH": return 2
			case "m": return 2
			case "mm": return 2
			case "s": return 2
			case "ss": return 2
			case "E": return 3
			case "EEEE": return nil
			case "EEEEE": return nil
			case "Q": return 1
			case "QQQ": return 2
			case "QQQQ": return nil
			case "W": return 2
			case "w": return 2
			case "ww": return 2
			case "YY": return 2
			case "Y": return 4
			case "YYYY": return 4
			case "SSS": return 3
			case "SSSS": return 4
			case "Z": return 5
			case "zzzz": return 9
			case "ZZZZZ": return 6
			case "zzz": return 6
			default: return nil
			}
		}
	}
}
#endif
