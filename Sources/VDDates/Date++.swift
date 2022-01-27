import Foundation

extension Calendar {
	public static var `default` = Calendar.autoupdatingCurrent
	
	public func current(_ component: Component) -> Int {
		self.component(component, from: Date())
	}
	
	public func name(forWeekday weekday: Int) -> String {
		standaloneWeekdaySymbols[weekday - firstWeekday]
	}
}

extension Locale {
	public static var `default` = Locale.autoupdatingCurrent
}

extension TimeZone {
    public static var `default` = TimeZone.autoupdatingCurrent
}

public enum Weekdays: Int, CustomStringConvertible {
	case sunday = 1, monday, tuesday, wednesday, thursday, friday, saturday

	public var description: String {
		switch self {
		case .sunday:       return "sunday"
		case .monday:       return "monday"
		case .tuesday:      return "tuesday"
		case .wednesday:    return "wednesday"
		case .thursday:     return "thursday"
		case .friday:       return "friday"
		case .saturday:     return "saturday"
		}
	}
}

extension DateComponents: RawRepresentable, ExpressibleByDictionaryLiteral {
	public static func era(_ value: Int) -> DateComponents { .current(era: value) }
	public static func year(_ value: Int) -> DateComponents { .current(year: value) }
	public static func month(_ value: Int) -> DateComponents { .current(month: value) }
	public static func day(_ value: Int) -> DateComponents { .current(day: value) }
	public static func hour(_ value: Int) -> DateComponents { .current(hour: value) }
	public static func minute(_ value: Int) -> DateComponents { .current(minute: value) }
	public static func second(_ value: Int) -> DateComponents { .current(second: value) }
	public static func weekday(_ value: Int) -> DateComponents { .current(weekday: value) }
	public static func weekday(_ value: Weekdays) -> DateComponents { .current(weekday: value.rawValue) }
	public static func weekdayOrdinal(_ value: Int) -> DateComponents { .current(weekdayOrdinal: value) }
	public static func quarter(_ value: Int) -> DateComponents { .current(quarter: value) }
	public static func weekOfMonth(_ value: Int) -> DateComponents { .current(weekOfMonth: value) }
	public static func weekOfYear(_ value: Int, year: Int) -> DateComponents { .current(weekOfYear: value, yearForWeekOfYear: year) }
	public static func week(_ value: Int) -> DateComponents { .current(weekOfYear: value) }
	public static func nanoseconds(_ value: Int) -> DateComponents { .current(nanosecond: value) }
	
	public subscript(_ component: Calendar.Component) -> Int? {
		get { self.component(component) }
		set { setValue(newValue, for: component) }
	}
	
	public var rawValue: [Calendar.Component: Int] {
		Dictionary(Calendar.Component.allCases.compactMap({ comp in component(comp).map({(comp, $0)})}), uniquingKeysWith: {_, s in s})
	}
	
	public init(dictionaryLiteral elements: (Calendar.Component, Int)...) {
		let dict = Dictionary(elements, uniquingKeysWith: {_, s in s})
		self = DateComponents(rawValue: dict)
	}
	
	public init(rawValue: [Calendar.Component: Int]) {
		self = DateComponents(
			calendar: nil,
			timeZone: nil,
			era: rawValue[.era],
			year: rawValue[.year],
			month: rawValue[.month],
			day: rawValue[.day],
			hour: rawValue[.hour],
			minute: rawValue[.minute],
			second: rawValue[.second],
			nanosecond: rawValue[.nanosecond],
			weekday: rawValue[.weekday],
			weekdayOrdinal: rawValue[.weekdayOrdinal],
			quarter: rawValue[.quarter],
			weekOfMonth: rawValue[.weekOfMonth],
			weekOfYear: rawValue[.weekOfYear],
			yearForWeekOfYear: rawValue[.yearForWeekOfYear]
		)
	}
	
	public init() {
		self = DateComponents(rawValue: [:])
	}
	
	public static func +(_ lhs: DateComponents, _ rhs: DateComponents) -> DateComponents {
		operation(lhs, rhs, +)
	}
	
	public static func -(_ lhs: DateComponents, _ rhs: DateComponents) -> DateComponents {
		operation(lhs, rhs, -)
	}
	
	public static func +=(_ lhs: inout DateComponents, _ rhs: DateComponents) {
		lhs = lhs + rhs
	}
	
	public static func -=(_ lhs: inout DateComponents, _ rhs: DateComponents) {
		lhs = lhs - rhs
	}
	
	private static func operation(_ lhs: DateComponents, _ rhs: DateComponents, _ block: (Int, Int) -> Int) -> DateComponents {
		.current(
			era: operation(block, lhs, rhs, at: \.era),
			year: operation(block, lhs, rhs, at: \.year),
			month: operation(block, lhs, rhs, at: \.month),
			day: operation(block, lhs, rhs, at: \.day),
			hour: operation(block, lhs, rhs, at: \.hour),
			minute: operation(block, lhs, rhs, at: \.minute),
			second: operation(block, lhs, rhs, at: \.second),
			nanosecond: operation(block, lhs, rhs, at: \.nanosecond),
			weekday: operation(block, lhs, rhs, at: \.weekday),
			weekdayOrdinal: operation(block, lhs, rhs, at: \.weekdayOrdinal),
			quarter: operation(block, lhs, rhs, at: \.quarter),
			weekOfMonth: operation(block, lhs, rhs, at: \.weekOfMonth),
			weekOfYear: operation(block, lhs, rhs, at: \.weekOfYear),
			yearForWeekOfYear: operation(block, lhs, rhs, at: \.yearForWeekOfYear)
		)
	}
	
	private static func operation(_ operation: (Int, Int) -> Int, _ lhs: DateComponents, _ rhs: DateComponents, at keyPath: KeyPath<DateComponents, Int?>) -> Int? {
		if let left = lhs[keyPath: keyPath] {
			return operation(left, (rhs[keyPath: keyPath] ?? 0))
		}
		return rhs[keyPath: keyPath].map { operation(0, $0) }
	}
	
	fileprivate static func current(timeZone: TimeZone? = .default, era: Int? = nil, year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil, nanosecond: Int? = nil, weekday: Int? = nil, weekdayOrdinal: Int? = nil, quarter: Int? = nil, weekOfMonth: Int? = nil, weekOfYear: Int? = nil, yearForWeekOfYear: Int? = nil) -> DateComponents {
		DateComponents(calendar: .default, timeZone: timeZone, era: era, year: year, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: nanosecond, weekday: weekday, weekdayOrdinal: weekdayOrdinal, quarter: quarter, weekOfMonth: weekOfMonth, weekOfYear: weekOfYear, yearForWeekOfYear: yearForWeekOfYear)
	}
	
	fileprivate func component(_ component: Calendar.Component) -> Int? {
		switch component {
		case .era:                  return era
		case .year:                 return year
		case .month:                return month
		case .day:                  return day
		case .hour:                 return hour
		case .minute:               return minute
		case .second:               return second
		case .weekday:              return weekday
		case .weekdayOrdinal:       return weekdayOrdinal
		case .quarter:              return quarter
		case .weekOfMonth:          return weekOfMonth
		case .weekOfYear:           return weekOfYear
		case .yearForWeekOfYear:    return yearForWeekOfYear
		case .nanosecond:           return nanosecond
		default:                    return nil
		}
	}
	
	public func contains(_ other: DateComponents) -> Bool {
		for (key, value) in other.rawValue {
			if component(key) != value { return false }
		}
		return true
	}
	
	fileprivate func minComponent() -> Int {
		let all = Set(rawValue.map { $0.key })
		let sorted = Calendar.Component.sorted
		return all.compactMap(sorted.firstIndex).first ?? 0
	}
	
}

extension Date {
	
	public static var today: Date { Date().start(of: .day) }
	public static var yesterday: Date { today - .day }
	public static var tomorrow: Date { today + .day }
	
    /// true if the given date is within today, as defined by default calendar and calendar’s locale; otherwise, false.
	public var isToday: Bool { Calendar.default.isDateInToday(self) }
    
    /// Returns a Boolean value indicating whether the given date is within today.
    /// - Parameter calendar: The calendar to use
    /// - Returns: true if the given date is within today, as defined by the calendar and calendar’s locale; otherwise, false.
	public func isToday(calendar: Calendar) -> Bool { calendar.isDateInToday(self) }
    
    ///true if the given date is within yesterday, as defined by default calendar and calendar’s locale; otherwise, false.
	public var isYesterday: Bool { start(of: .day) == .yesterday }
    
    /// Returns a Boolean value indicating whether the given date is within today.
    /// - Parameter calendar: The calendar to use
    /// - Returns: true if the given date is within yesterday, as defined by the calendar and calendar’s locale; otherwise, false.
	public func isYesterday(calendar: Calendar) -> Bool { start(of: .day, calendar: calendar) == .yesterday }
    
    ///true if the given date is within tomorrow, as defined by default calendar and calendar’s locale; otherwise, false.
	public var isTomorrow: Bool { Calendar.default.isDateInTomorrow(self) }
    
    /// Returns a Boolean value indicating whether the given date is within today.
    /// - Parameter calendar: The calendar to use
    /// - Returns: true if the given date is within tomorrow, as defined by the calendar and calendar’s locale; otherwise, false.
	public func isTomorrow(calendar: Calendar) -> Bool { calendar.isDateInTomorrow(self) }
    
    ///true if the given date is within current week, as defined by default calendar and calendar’s locale; otherwise, false.
	public var isCurrentWeek: Bool { start(of: .week) == Date.today.start(of: .week) }
    
    /// Returns a Boolean value indicating whether the given date is within today.
    /// - Parameter calendar: The calendar to use
    /// - Returns: true if the given date is within current week, as defined by the calendar and calendar’s locale; otherwise, false.
	public func isCurrentWeek(calendar: Calendar) -> Bool {
		start(of: .week, calendar: calendar) == Date.today.start(of: .week, calendar: calendar)
	}
    
	public var iso860: String {
		string("yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX", locale: Locale(identifier: "en_US_POSIX"), timeZone: TimeZone(secondsFromGMT: 0) ?? .default)
	}
	
	public init(era: Int = 1, year: Int, month: Int = 1, day: Int = 1, hour: Int = 0, minute: Int = 0, second: Int = 0, nanosecond: Int = 0, calendar: Calendar = .default, timeZone: TimeZone = .default) {
		self = DateComponents(calendar: calendar, timeZone: timeZone, era: era, year: year, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: nanosecond).date ?? Date()
	}
	
	public init?(components: DateComponents, calendar: Calendar = .default, timeZone: TimeZone = .default) {
		var components = components
		components.calendar = calendar
		components.timeZone = timeZone
		guard let date = components.date else { return nil }
		self = date
	}
	
	public init?(from string: String, format: String, locale: Locale = .default, timezone: TimeZone = .default) {
		let formatter = DateFormatter()
		formatter.dateFormat = format
		formatter.locale = locale
		formatter.timeZone = timezone
		guard let date = formatter.date(from: string) else { return nil }
		self = date
	}
	
	public func components(calendar: Calendar = .default) -> DateComponents {
		calendar.dateComponents(Calendar.Component.allCases, from: self)
	}
    
    public func components(in component: Calendar.Component, calendar: Calendar = .default) -> DateComponents {
        let components = self.components(calendar: calendar).rawValue.filter {
            $0.key < component
        }
        return DateComponents(rawValue: components)
    }
    
    /// Returns the value for one component of a date.
    /// - Parameters:
    ///   - component: The component to calculate
    ///   - calendar: The calendar to use
    /// - Returns: The value for the component.
	public func component(_ component: Calendar.Component, calendar: Calendar = .default) -> Int {
		calendar.component(component, from: self)
	}
    
    /// Returns the value for one component of a date.
    /// - Parameters:
    ///   - component: The component to calculate
    ///   - calendar: The calendar to use
    /// - Returns: The value for the component.
    public subscript(_ component: Calendar.Component, calendar: Calendar = .default) -> Int {
        get { calendar.component(component, from: self) }
        set { set(newValue, component, calendar: calendar) }
    }
    
    /// Returns the first moment of a given Date, as a Date.
    ///
    /// For example, pass in `.day`, if you want the start of today.
    /// - Parameters:
    ///   - component: The component to compute for
    ///   - calendar: The calendar to use
    /// - Returns: The first moment of the given date.
	public func start(of component: Calendar.Component, calendar: Calendar = .default) -> Date {
		if component == .day {
			return calendar.startOfDay(for: self)
		}
		var set = component.allLarger
		set.insert(component)
		return calendar.date(from: calendar.dateComponents(set, from: self)) ?? self
	}
    
    /// Returns the last moment of a given Date, as a Date, with given accuracy.
    ///
    /// For example, pass in `.day`, if you want the start of today.
    /// - Parameters:
    ///   - component: The component to compute for
    ///   - accuracy: The component to compute for
    ///   - calendar: The calendar to use
    /// - Returns: The last moment of the given date.
	public func end(of component: Calendar.Component, accuracy: Calendar.Component? = nil, calendar: Calendar = .default) -> Date {
		var smaller: Calendar.Component?
		if let smallest = accuracy, calendar.range(of: smallest, in: component, for: self) != nil {
			if smallest == .nanosecond {
				smaller = .second
			} else {
				smaller = smallest
			}
		} else {
			smaller = component.smaller
		}
		guard let next = smaller else { return self }
		var components = DateComponents()
		components.setValue(1, for: component)
		components.setValue(-1, for: next)
		return calendar.date(byAdding: components, to: start(of: component, calendar: calendar)) ?? self
	}
	
	public func matches(_ components: DateComponents, calendar: Calendar = .default) -> Bool {
		for component in Calendar.Component.allCases {
			guard let value = components.component(component) else { continue }
			if calendar.component(component, from: self) != value {
				return false
			}
		}
		return true
	}
    
    public func isInSame(_ component: Calendar.Component, as date: Date, calendar: Calendar = .default) -> Bool {
        if component == .day {
            return calendar.isDate(self, inSameDayAs: date)
        }
        return start(of: component, calendar: calendar) == date.start(of: component, calendar: calendar)
    }
    
    public func isEqual(to date: Date, toGranularity: Calendar.Component, calendar: Calendar = .default) -> Bool {
        calendar.isDate(self, equalTo: date, toGranularity: toGranularity)
    }
    
	public func interval(of component: Calendar.Component, from date: Date, calendar: Calendar = .default) -> Int {
		calendar.dateComponents([component], from: date.start(of: component, calendar: calendar), to: start(of: component, calendar: calendar)).component(component) ?? 0
	}
	
	public func range(of smaller: Calendar.Component, in larger: Calendar.Component, calendar: Calendar = .default) -> Range<Int>? {
		calendar.range(of: smaller, in: larger, for: self)
	}
	
	public func range(byAdding difference: DateDifference, calendar: Calendar = .default) -> Range<Date> {
		let new = self.adding(difference)
		if new < self {
			return new..<self
		} else if self == new {
			return self..<(self + .second)
		}
		return self..<new
	}
	
	public func dates(of smaller: Calendar.Component, in larger: Calendar.Component, calendar: Calendar = .default) -> Range<Date>? {
		let lower = start(of: larger, calendar: calendar)
		let upper = end(of: larger, accuracy: smaller, calendar: calendar)
		guard upper > lower else { return nil }
		return lower..<upper
	}
	
    public func count(of smaller: Calendar.Component, calendar: Calendar = .default) -> Int {
        smaller.larger.map { count(of: smaller, in: $0, calendar: calendar) } ?? 1
    }
        
	public func count(of smaller: Calendar.Component, in larger: Calendar.Component, calendar: Calendar = .default) -> Int {
		if smaller.larger == larger || larger.smaller == smaller {
			return range(of: smaller, in: larger, calendar: calendar)?.count ?? 0
		} else {
			let from = start(of: larger, calendar: calendar)
			return from.adding(larger, value: 1, calendar: calendar).interval(of: smaller, from: from, calendar: calendar)
		}
	}
	
	public func string(_ format: String, locale: Locale = .default, timeZone: TimeZone = .default) -> String {
		let formatter = DateFormatter()
		formatter.locale = locale
		formatter.dateFormat = format
		formatter.timeZone = timeZone
		return formatter.string(from: self)
	}
	
	public func string(date: DateFormatter.Style = .short, time: DateFormatter.Style = .none, locale: Locale = .default, timeZone: TimeZone = .default) -> String {
		let formatter = DateFormatter()
		formatter.locale = locale
		formatter.timeZone = timeZone
		formatter.dateStyle = date
		formatter.timeStyle = time
		return formatter.string(from: self)
	}
	
	public func string(_ format: String, relative: [DateComponents: String], to date: Date = Date(), locale: Locale = .default, timeZone: TimeZone = .default, calendar: Calendar = .default) -> String {
		guard !relative.isEmpty else { return string(format, locale: locale, timeZone: timeZone) }
		let difference = from(date).dateComponents(calendar: calendar)
		for (comp, format) in relative.sorted(by: { $0.key.minComponent() < $1.key.minComponent() }) {
			if difference.contains(comp) {
				return string(format, locale: locale, timeZone: timeZone)
			}
		}
		return string(format, locale: locale, timeZone: timeZone)
	}
	
	public func name(of component: Calendar.Component, locale: Locale = .default, timeZone: TimeZone = .default) -> String {
		switch component {
		case .era:                  return string("GGGG", locale: locale, timeZone: timeZone)
		case .year:                 return string("yyyy", locale: locale, timeZone: timeZone)
		case .month:                return string("MMMM", locale: locale, timeZone: timeZone)
		case .day:                  return string("dd", locale: locale, timeZone: timeZone)
		case .hour:                 return string("HH", locale: locale, timeZone: timeZone)
		case .minute:               return string("mm", locale: locale, timeZone: timeZone)
		case .second:               return string("ss", locale: locale, timeZone: timeZone)
		case .weekday:              return string("EEEE", locale: locale, timeZone: timeZone)
		case .weekdayOrdinal:       return string("EEEE", locale: locale, timeZone: timeZone)
		case .quarter:              return string("QQQQ", locale: locale, timeZone: timeZone)
		case .weekOfMonth:          return string("W", locale: locale, timeZone: timeZone)
		case .weekOfYear:           return string("w", locale: locale, timeZone: timeZone)
		case .yearForWeekOfYear:    return string("Y", locale: locale, timeZone: timeZone)
		case .nanosecond:           return "\(nanosecond())"
		case .calendar:             return ""
		case .timeZone:             return string("ZZZZ", locale: locale, timeZone: timeZone)
		@unknown default:           return ""
		}
	}
	
	@available(*, deprecated, message: "Use ordinality instead")
	public func position(of smaller: Calendar.Component, in larger: Calendar.Component, startFromZero: Bool = true, calendar: Calendar = .default) -> Int {
		interval(of: smaller, from: start(of: larger, calendar: calendar), calendar: calendar) + (startFromZero ? 0 : smaller.first)
	}
    
    /// Returns, for a given absolute time, the ordinal number of a smaller calendar component (such as a day) within a specified larger calendar component (such as a week).
    /// ```swift
    /// date.ordinality(of: .day, in: .week)
    /// ```
    /// The ordinality is in most cases not the same as the decomposed value of the component. Typically return values are 1 and greater. For example, the time 00:45 is in the first hour of the day, and for components hour and day respectively, the result would be 1. An exception is the week-in-month calculation, which returns 0 for days before the first week in the month containing the date.
    /// - Note:
    ///        Some computations can take a relatively long time.
    /// - Parameters:
    ///   - smaller: The smaller calendar component.
    ///   - larger: The larger calendar component.
    ///   - calendar: The calendar to use
    /// - Returns: The ordinal number of smaller within larger at the time specified by date. Returns nil if larger is not logically bigger than smaller in the calendar, or the given combination of components does not make sense (or is a computation which is undefined).
    public func ordinality(of smaller: Calendar.Component, in larger: Calendar.Component, calendar: Calendar = .default) -> Int? {
        calendar.ordinality(of: smaller, in: larger, for: self)
    }
	
	public func from(_ other: Date) -> DateDifference {
		.dates(from: other, to: self)
	}
	
	public func to(_ other: Date) -> DateDifference {
		other.from(self)
	}
	
	public static func -(_ lhs: Date, _ rhs: Date) -> DateDifference {
		lhs.from(rhs)
	}
	
	public func adding(_ difference: DateDifference, wrapping: Bool = false, calendar: Calendar = .default) -> Date {
		switch difference {
		case .interval(let interval):
			return addingTimeInterval(interval)
		case .dates(let from, let to):
			return addingTimeInterval(to.timeIntervalSince(from))
		case .components(let components):
			return calendar.date(byAdding: DateComponents(rawValue: components), to: self, wrappingComponents: wrapping) ?? addingTimeInterval(TimeInterval(difference.seconds))
		}
	}
	
	public mutating func add(_ difference: DateDifference, wrapping: Bool = false, calendar: Calendar = .default) {
		self = adding(difference, wrapping: wrapping, calendar: calendar)
	}
	
	public func adding(components: DateComponents, wrapping: Bool = false, calendar: Calendar = .default) -> Date? {
		calendar.date(byAdding: components, to: self, wrappingComponents: wrapping)
	}
	
	public mutating func add(_ component: Calendar.Component, value: Int, wrapping: Bool = false, calendar: Calendar = .default) {
		self = adding(component, value: value, wrapping: wrapping, calendar: calendar)
	}
	
	public func adding(_ component: Calendar.Component, value: Int, wrapping: Bool = false, calendar: Calendar = .default) -> Date {
		calendar.date(byAdding: component, value: value, to: self, wrappingComponents: wrapping) ?? addingTimeInterval(TimeInterval(value * count(of: .second, in: component)))
	}
    
    @discardableResult
    public mutating func set(_ value: Int, _ component: Calendar.Component, calendar: Calendar = .default) -> Bool {
        let result = setting(value, component, calendar: calendar)
        self = result ?? self
        return result != nil
    }
    
    @available(*, deprecated, message: "Use set(value, component)")
	@discardableResult
	public mutating func set(_ component: Calendar.Component, value: Int, calendar: Calendar = .default) -> Bool {
        set(value, component, calendar: calendar)
	}
    
    public mutating func set(_ components: DateComponents, calendar: Calendar = .default) {
        self = setting(components, calendar: calendar)
    }
    
    public func setting(_ components: DateComponents, calendar: Calendar = .default) -> Date {
        components.rawValue.sorted(by: { $0.key > $1.key }).reduce(self) {
            $0.setting($1.value, $1.key) ?? $0
        }
    }
    
    @available(*, deprecated, message: "Use setting(value, component)")
    public func setting(_ component: Calendar.Component, value: Int, calendar: Calendar = .default) -> Date? {
        setting(value, component, calendar: calendar)
    }
    
	public func setting(_ value: Int, _ component: Calendar.Component, calendar: Calendar = .default) -> Date? {
        switch component {
        case .nanosecond, .second, .minute, .hour:
            var comps = components(calendar: calendar)
            comps.setValue(value, for: component)
            return calendar.date(from: comps)
        case .day, .weekday, .weekdayOrdinal, .weekOfYear, .weekOfMonth, .era, .month, .quarter, .year, .yearForWeekOfYear:
            let diff = value - self.component(component, calendar: calendar)
            return adding(component, value: diff, calendar: calendar)
        case .calendar, .timeZone:
            return nil
        @unknown default:
            return nil
        }
	}
	
	public func compare(with date: Date, accuracy component: Calendar.Component, calendar: Calendar = .default) -> ComparisonResult {
		calendar.compare(self, to: date, toGranularity: component)
	}
	
	@available(iOS 10.0, macOS 10.12, *)
	public func nextWeekend(direction: Calendar.SearchDirection = .forward, calendar: Calendar = .default) -> DateInterval? {
		calendar.nextWeekend(startingAfter: self, direction: direction)
	}
	
	public func next(_ component: Calendar.Component, direction: Calendar.SearchDirection = .forward, count: Int = 1, calendar: Calendar = .default) -> Date {
		switch direction {
		case .forward:
			return calendar.date(byAdding: component, value: count, to: self)?.start(of: component, calendar: calendar) ?? self
		case .backward:
			return adding([component: -count], calendar: calendar).start(of: component, calendar: calendar)
		@unknown default: return self
		}
	}
	
	public func nearest(_ components: DateComponents, in time: Calendar.SearchDirection.Set = .both, matchingPolicy: Calendar.MatchingPolicy = .strict, calendar: Calendar = .default) -> Date? {
		guard !time.isEmpty else { return nil }
		var next: Date?
		var prev: Date?
		if time.contains(.future) {
			next = calendar.nextDate(after: self, matching: components, matchingPolicy: matchingPolicy, direction: .forward)
		}
		if time.contains(.past) {
			prev = calendar.nextDate(after: self, matching: components, matchingPolicy: matchingPolicy, direction: .backward)
		}
		if let nxt = next, let prv = prev {
			return abs(nxt.timeIntervalSince(self)) < abs(prv.timeIntervalSince(self)) ? nxt : prv
		}
		return next ?? prev
	}
    
    public func rounded(_ component: Calendar.Component, by value: Int, calendar: Calendar = .default) -> Date {
        guard value > 0 else { return setting(value, component, calendar: calendar) ?? self }
        var count = self.component(component, calendar: calendar)
        count = Int(Foundation.round(Double(count) / Double(value))) * value
        return setting(count, component, calendar: calendar) ?? self
    }
    
    public mutating func round(_ component: Calendar.Component, by value: Int, calendar: Calendar = .default) {
        self = rounded(component, by: value, calendar: calendar)
    }
    
    public func rounded(_ component: Calendar.Component, from date: Date, by value: Int, calendar: Calendar = .default) -> Date {
        guard value > 0 else { return setting(value, component, calendar: calendar) ?? self }
        var count = interval(of: component, from: date, calendar: calendar)
        count = Int(Foundation.round(Double(count) / Double(value))) * value
        return date + .components([component: count])
    }
    
    public mutating func round(_ component: Calendar.Component, from date: Date, by value: Int, calendar: Calendar = .default) {
        self = rounded(component, from: date, by: value, calendar: calendar)
    }

	public func month(in larger: Calendar.Component, calendar: Calendar = .default) -> Int? { ordinality(of: .month, in: larger, calendar: calendar) }
	public func day(in larger: Calendar.Component, calendar: Calendar = .default) -> Int? { ordinality(of: .day, in: larger, calendar: calendar) }
	public func hour(in larger: Calendar.Component, calendar: Calendar = .default) -> Int? { ordinality(of: .hour, in: larger, calendar: calendar) }
	public func minute(in larger: Calendar.Component, calendar: Calendar = .default) -> Int? { ordinality(of: .minute, in: larger, calendar: calendar) }
	public func second(in larger: Calendar.Component, calendar: Calendar = .default) -> Int? { ordinality(of: .second, in: larger, calendar: calendar) }
	public func nanosecond(in larger: Calendar.Component, calendar: Calendar = .default) -> Int? { ordinality(of: .nanosecond, in: larger, calendar: calendar) }
	public func weekday(in larger: Calendar.Component, calendar: Calendar = .default) -> Int? { ordinality(of: .weekday, in: larger, calendar: calendar) }
	public func quarter(in larger: Calendar.Component, calendar: Calendar = .default) -> Int? { ordinality(of: .quarter, in: larger, calendar: calendar) }
	public func week(in larger: Calendar.Component, calendar: Calendar = .default) -> Int? { ordinality(of: .weekOfYear, in: larger, calendar: calendar) }
	
	public func era(calendar: Calendar = .default) -> Int { calendar.component(.era, from: self) }
	public func year(calendar: Calendar = .default) -> Int { calendar.component(.year, from: self) }
	public func month(calendar: Calendar = .default) -> Int { calendar.component(.month, from: self) }
	public func day(calendar: Calendar = .default) -> Int { calendar.component(.day, from: self) }
	public func hour(calendar: Calendar = .default) -> Int { calendar.component(.hour, from: self) }
	public func minute(calendar: Calendar = .default) -> Int { calendar.component(.minute, from: self) }
	public func second(calendar: Calendar = .default) -> Int { calendar.component(.second, from: self) }
	public func nanosecond(calendar: Calendar = .default) -> Int { calendar.component(.nanosecond, from: self) }
	public func weekday(calendar: Calendar = .default) -> Weekdays { Weekdays(rawValue: calendar.component(.weekday, from: self)) ?? .sunday }
	public func weekdayOrdinal(calendar: Calendar = .default) -> Int { calendar.component(.weekdayOrdinal, from: self) }
	public func quarter(calendar: Calendar = .default) -> Int { calendar.component(.quarter, from: self) }
	public func weekOfMonth(calendar: Calendar = .default) -> Int { calendar.component(.weekOfMonth, from: self) }
	public func weekOfYear(calendar: Calendar = .default) -> Int { calendar.component(.weekOfYear, from: self) }
	public func yearForWeekOfYear(calendar: Calendar = .default) -> Int { calendar.component(.yearForWeekOfYear, from: self) }
    
    public var era: Int { get { self[.era] } set { self[.era] = newValue } }
    public var year: Int { get { self[.year] } set { self[.year] = newValue } }
    public var month: Int { get { self[.month] } set { self[.month] = newValue } }
    public var day: Int { get { self[.day] } set { self[.day] = newValue } }
    public var hour: Int { get { self[.hour] } set { self[.hour] = newValue } }
    public var minute: Int { get { self[.minute] } set { self[.minute] = newValue } }
    public var second: Int { get { self[.second] } set { self[.second] = newValue } }
    public var nanosecond: Int { get { self[.nanosecond] } set { self[.nanosecond] = newValue } }
    public var weekday: Int { get { self[.weekday] } set { self[.weekday] = newValue } }
    public var weekdayOrdinal: Int { get { self[.weekdayOrdinal] } set { self[.weekdayOrdinal] = newValue } }
    public var quarter: Int { get { self[.quarter] } set { self[.quarter] = newValue } }
    public var weekOfMonth: Int { get { self[.weekOfMonth] } set { self[.weekOfMonth] = newValue } }
    public var weekOfYear: Int { get { self[.weekOfYear] } set { self[.weekOfYear] = newValue } }
    public var yearForWeekOfYear: Int { get { self[.yearForWeekOfYear] } set { self[.yearForWeekOfYear] = newValue } }
}

public enum DateDifference: Hashable, Equatable, Comparable, ExpressibleByDictionaryLiteral {
	case interval(TimeInterval), dates(from: Date, to: Date), components([Calendar.Component: Int])
	
	public var eras: Int { component(.era) }
	public var years: Int { component(.year) }
	public var quarters: Int { component(.quarter) }
	public var months: Int { component(.month) }
	public var weeks: Int { component(.week) }
	public var days: Int { component(.day) }
	public var hours: Int { component(.hour) }
	public var minutes: Int { component(.minute) }
	public var seconds: Int { component(.second) }
	public var nanoseconds: Int { component(.nanosecond) }
	
	public subscript(_ component: Calendar.Component, calendar: Calendar = .default) -> Int {
		self.component(component, calendar: calendar)
	}
	
	public var interval: TimeInterval {
		switch self {
		case .dates(let from, let to):
			return to.timeIntervalSince(from)
		case .interval(let interval):
			return interval
		case .components(let dict):
			return dict.reduce(0, { $0 + TimeInterval($1.value) * $1.key.inSeconds })
		}
	}
	
	public func dateComponents(calendar: Calendar = .default) -> DateComponents {
		DateComponents(
			rawValue: Dictionary(
				Calendar.Component.allCases.map {
					($0, component($0, calendar: calendar))
				},
				uniquingKeysWith: { _, p in p }
			)
		)
	}
	
	public func component(_ component: Calendar.Component, calendar: Calendar = .default) -> Int {
		switch self {
		case .interval(let seconds):
			return Int(Calendar.Component.second.as(component) * seconds)
		case .dates(let from, let to):
			return to.interval(of: component, from: from, calendar: calendar)
		case .components(let dict):
			return Int(dict.reduce(0, { $0 + Double($1.value) * $1.key.as(component) }))
		}
	}
	
	public init(dictionaryLiteral elements: (Calendar.Component, Int)...) {
		let dict = Dictionary(elements, uniquingKeysWith: {_, s in s})
		self = .components(dict)
	}
	
	public init(components: DateComponents) {
		self = .components(components.rawValue)
	}
	
	public static var era: DateDifference { .eras(1) }
	public static var year: DateDifference { .years(1) }
	public static var quarter: DateDifference { .quarters(1) }
	public static var month: DateDifference { .months(1) }
	public static var week: DateDifference { .weeks(1) }
	public static var day: DateDifference { .days(1) }
	public static var hour: DateDifference { .hours(1) }
	public static var minute: DateDifference { .minutes(1) }
	public static var second: DateDifference { .seconds(1) }
	public static var nanosecond: DateDifference  { .nanoseconds(1) }
	
	public static func eras(_ value: Int) -> DateDifference { [.era: value] }
	public static func years(_ value: Int) -> DateDifference { [.year: value] }
	public static func quarters(_ value: Int) -> DateDifference { [.quarter: value] }
	public static func months(_ value: Int) -> DateDifference { [.month: value] }
	public static func weeks(_ value: Int) -> DateDifference { [.week: value] }
	public static func days(_ value: Int) -> DateDifference { [.day: value] }
	public static func hours(_ value: Int) -> DateDifference { [.hour: value] }
	public static func minutes(_ value: Int) -> DateDifference { [.minute: value] }
	public static func seconds(_ value: Int) -> DateDifference { [.second: value] }
	public static func nanoseconds(_ value: Int) -> DateDifference { [.nanosecond: value] }
	
	public static func +(_ lhs: DateDifference, _ rhs: DateDifference) -> DateDifference {
		operation(lhs, rhs, +, +)
	}
	
	public static func +=(_ lhs: inout DateDifference, _ rhs: DateDifference) {
		lhs = lhs + rhs
	}
	
	public static func -(_ lhs: DateDifference, _ rhs: DateDifference) -> DateDifference {
		operation(lhs, rhs, -, -)
	}
	
	public static func -=(_ lhs: inout DateDifference, _ rhs: DateDifference) {
		lhs = lhs - rhs
	}
	
	public static func /(_ lhs: DateDifference, _ rhs: Int) -> DateDifference {
		operation(lhs, rhs, /, /)
	}
	
	public static func /=(_ lhs: inout DateDifference, _ rhs: Int) {
		lhs = lhs / rhs
	}
	
	public static func *(_ lhs: DateDifference, _ rhs: Int) -> DateDifference {
		operation(lhs, rhs, *, *)
	}
	
	public static func *(_ lhs: Int, _ rhs: DateDifference) -> DateDifference {
		rhs * lhs
	}
	
	public static func *=(_ lhs: inout DateDifference, _ rhs: Int) {
		lhs = lhs * rhs
	}
	
	public static func <(lhs: DateDifference, rhs: DateDifference) -> Bool {
		compare(lhs: lhs, rhs: rhs, operation: <)
	}
	
	public static func ==(lhs: DateDifference, rhs: DateDifference) -> Bool {
		compare(lhs: lhs, rhs: rhs, operation: ==)
	}
	
	private static func compare(lhs: DateDifference, rhs: DateDifference, operation: (TimeInterval, TimeInterval) -> Bool) -> Bool {
		switch (lhs, rhs) {
		case (.dates, .dates):
			return operation(lhs.interval, rhs.interval)
		case (.dates(let from, let to), _):
			return operation(to.timeIntervalSince(from), from.adding(rhs).timeIntervalSince(from))
		case (_, .dates(let from, let to)):
			return operation(from.adding(lhs).timeIntervalSince(from), to.timeIntervalSince(from))
		default:
			return operation(lhs.interval, rhs.interval)
		}
	}
	
	fileprivate static func operation(_ lhs: DateDifference, _ rhs: DateDifference, _ block1: (TimeInterval, TimeInterval) -> TimeInterval, _ block2: (Int, Int) -> Int) -> DateDifference {
		switch (lhs, rhs) {
		case (.components(let left), .components(let right)):
			var result = left
			right.forEach {
				result[$0.key] = block2(result[$0.key] ?? 0, $0.value)
			}
			return .components(result)
		case (.interval(let left), .interval(let right)):
			return .interval(block1(left, right))
		case (.dates(let from, let to), .interval(let interval)):
			return .dates(from: from, to: from.addingTimeInterval(block1(to.timeIntervalSince(from), interval)))
		case (.interval(let interval), .dates(let from, let to)):
			return .dates(from: from, to: from.addingTimeInterval(block1(interval, to.timeIntervalSince(from))))
		default:
			return operation(.interval(lhs.interval), .interval(rhs.interval), block1, block2)
		}
	}
	
	fileprivate static func operation(_ lhs: DateDifference, _ rhs: Int, _ block1: (TimeInterval, TimeInterval) -> TimeInterval, _ block2: (Int, Int) -> Int) -> DateDifference {
		switch lhs {
		case .interval(let interval):
			return .interval(block1(interval, TimeInterval(rhs)))
		case .dates(let from, let to):
			return .dates(from: from, to: from.addingTimeInterval(block1(to.timeIntervalSince(from), TimeInterval(rhs))))
		case .components(let lhs):
			return .components(lhs.mapValues { block2($0, rhs) })
		}
	}
	
	fileprivate static func operation(_ operation: (Int, Int) -> Int, _ lhs: DateDifference, _ rhs: Int, at keyPath: KeyPath<DateDifference, Int>) -> Int {
		operation(lhs[keyPath: keyPath], rhs)
	}
	
	fileprivate static func operation(_ operation: (Int, Int) -> Int, _ lhs: DateDifference, _ rhs: DateDifference, at keyPath: KeyPath<DateDifference, Int>) -> Int {
		operation(lhs[keyPath: keyPath], rhs[keyPath: keyPath])
	}
}

extension BinaryInteger {
	public var eras: DateDifference { .eras(Int(self)) }
	public var years: DateDifference { .years(Int(self)) }
	public var quarters: DateDifference { .quarters(Int(self)) }
	public var months: DateDifference { .months(Int(self)) }
	public var weeks: DateDifference { .weeks(Int(self)) }
	public var days: DateDifference { .days(Int(self)) }
	public var hours: DateDifference { .hours(Int(self)) }
	public var minutes: DateDifference { .minutes(Int(self)) }
	public var seconds: DateDifference { .seconds(Int(self)) }
	public var nanoseconds: DateDifference { .nanoseconds(Int(self)) }
}

public prefix func -(_ rhs: DateDifference) -> DateDifference {
	-1 * rhs
}

public func +(_ lhs: Date, _ rhs: DateDifference) -> Date {
	lhs.adding(rhs)
}

public func -(_ lhs: Date, _ rhs: DateDifference) -> Date {
	lhs.adding(-rhs)
}

public func +=(_ lhs: inout Date, _ rhs: DateDifference) {
	lhs = lhs + rhs
}

public func -=(_ lhs: inout Date, _ rhs: DateDifference) {
	lhs = lhs - rhs
}

extension DateFormatter {
	
	public convenience init(_ format: String) {
		self.init()
		dateFormat = format
		locale = .default
	}
}

extension ClosedRange where Bound == Date {
	
	public func each(_ component: Calendar.Component, step: Int = 1, calendar: Calendar = .default) -> DatesCollection {
		let count = upperBound.interval(of: component, from: lowerBound) + 1
		return DatesCollection(from: lowerBound, count: count, component: component, step: step, calendar: calendar)
	}
}

extension Range where Bound == Date {
	
	public func each(_ component: Calendar.Component, step: Int = 1, calendar: Calendar = .default) -> DatesCollection {
		let count = upperBound.interval(of: component, from: lowerBound)
		return DatesCollection(from: lowerBound, count: count, component: component, step: step, calendar: calendar)
	}
}

@available(iOS 10.0, macOS 10.12, *)
extension DateInterval {
	
	public var difference: DateDifference {
		end - start
	}
	
	public func each(_ component: Calendar.Component, step: Int = 1, calendar: Calendar = .default) -> DatesCollection {
		return (start..<end).each(component, step: step, calendar: calendar)
	}
	
}

public struct DatesCollection: Collection, RandomAccessCollection {
	public var array: [Date] { Array(self) }
	public var startIndex: Int { 0 }
	public var endIndex: Int { count }
	public var start: Date
	public var count: Int
	public var component: Calendar.Component
	public var step: Int
	public var calendar: Calendar = .default
	
	public init(from date: Date, count: Int, component: Calendar.Component, step: Int, calendar: Calendar = .default) {
		start = date
		self.component = component
		self.step = step
		self.count = count
		self.calendar = calendar
	}
	
	public subscript(position: Int) -> Date {
		calendar.date(byAdding: component, value: position * step, to: start) ?? start
	}
	
	public func index(after i: Int) -> Int {
		i + 1
	}
    
    public func index(_ i: Int, offsetBy distance: Int) -> Int {
        i + distance
    }
}

extension Calendar.SearchDirection {
	
	public enum Set: UInt8, OptionSet {
		case future = 1, past = 2, both = 3, none = 0
		
		public init(rawValue: UInt8) {
			switch rawValue % 4 {
			case 0: self = .none
			case 1: self = .future
			case 2: self = .past
			default: self = .both
			}
		}
	}
}
