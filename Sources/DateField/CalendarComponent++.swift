//
//  CalendarComponent++.swift
//  DateField
//
//  Created by Данил Войдилов on 27.01.2022.
//

import Foundation

extension Calendar.Component {
	var allCases: [Int]? {
		switch self {
		case .era:
			return [0, 1]
		case .year: return nil
		case .month: return Array(1...12)
		case .day: return Array(1...31)
		case .hour: return Array(0..<24)
		case .minute: return Array(0..<60)
		case .second: return Array(0..<60)
		case .weekday: return Array(1...7)
		case .weekdayOrdinal: return Array(1...7)
		case .quarter: return Array(0..<4)
		case .weekOfMonth: return Array(1...6)
		case .weekOfYear: return Array(1...54)
		case .yearForWeekOfYear: return Array(1...54)
		case .nanosecond: return nil
		case .calendar: return nil
		case .timeZone: return nil
		@unknown default: return nil
		}
	}
	var maxValue: Int? {
		switch self {
		case .era: return 1
		case .year: return nil
		case .month: return 12
		case .day: return 31
		case .hour: return 23
		case .minute: return 59
		case .second: return 59
		case .weekday: return 7
		case .weekdayOrdinal: return 7
		case .quarter: return 3
		case .weekOfMonth: return 6
		case .weekOfYear: return 54
		case .yearForWeekOfYear: return 54
		case .nanosecond: return nil
		case .calendar: return nil
		case .timeZone: return nil
		@unknown default: return nil
		}
	}
}
