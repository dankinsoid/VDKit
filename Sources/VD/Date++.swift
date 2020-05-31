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
    
}

extension Date {
    
    public static var today: Date { Date().start(of: .day) }
    public static var yesterday: Date { today - .day }
    public static var tomorrow: Date { today + .day }
    
    public var isToday: Bool { start(of: .day) == .today }
    public var isYesterday: Bool { start(of: .day) == .yesterday }
    public var isTomorrow: Bool { start(of: .day) == .tomorrow }
    public var isCurrentWeek: Bool { start(of: .week) == Date.today.start(of: .week) }
    public var iso860: String {
        string("yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX", locale: Locale(identifier: "en_US_POSIX"), timeZone: TimeZone(secondsFromGMT: 0) ?? .default)
    }
    
    public func components(calendar: Calendar = .default) -> DateComponents {
        calendar.dateComponents(Calendar.Component.allCases, from: self)
    }
    
    public func component(_ component: Calendar.Component, calendar: Calendar = .default) -> Int {
        calendar.component(component, from: self)
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
    
    public func start(of component: Calendar.Component, calendar: Calendar = .default) -> Date {
        if component == .day {
            return calendar.startOfDay(for: self)
        }
        var set = component.allLarger
        set.insert(component)
        return calendar.date(from: calendar.dateComponents(set, from: self)) ?? self
    }
    
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
    
    public func interval(of component: Calendar.Component, from date: Date, calendar: Calendar = .default) -> Int {
        calendar.dateComponents([component], from: date.start(of: component, calendar: calendar), to: start(of: component, calendar: calendar)).component(component) ?? 0
    }
    
    public func range(of smaller: Calendar.Component, in larger: Calendar.Component, calendar: Calendar = .default) -> Range<Int>? {
        calendar.range(of: smaller, in: larger, for: self)
    }
    
    public func dates(of smaller: Calendar.Component, in larger: Calendar.Component, calendar: Calendar = .default) -> Range<Date>? {
        let lower = start(of: larger, calendar: calendar)
        let upper = end(of: larger, accuracy: smaller, calendar: calendar)
        guard upper > lower else { return nil }
        return lower..<upper
    }
    
    public func count(of smaller: Calendar.Component, in larger: Calendar.Component, calendar: Calendar = .default) -> Int {
        range(of: smaller, in: larger, calendar: calendar)?.count ?? 0
    }
    
    public func string(_ format: String, locale: Locale = .default, timeZone: TimeZone = .default) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = format
        formatter.timeZone = timeZone
        return formatter.string(from: self)
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
    
    public func position(of smaller: Calendar.Component, in larger: Calendar.Component, startFromZero: Bool = true, calendar: Calendar = .default) -> Int {
        interval(of: smaller, from: start(of: larger, calendar: calendar), calendar: calendar) + (startFromZero ? 0 : smaller.first)
    }
    
    public func from(_ other: Date, calendar: Calendar = .default) -> DateDifference {
        DateDifference(
            eras: interval(of: .era, from: other, calendar: calendar),
            years: interval(of: .year, from: other, calendar: calendar),
            quarters: interval(of: .quarter, from: other, calendar: calendar),
            months: interval(of: .month, from: other, calendar: calendar),
            weeks: interval(of: .weekOfYear, from: other, calendar: calendar),
            days: interval(of: .day, from: other, calendar: calendar),
            hours: interval(of: .hour, from: other, calendar: calendar),
            minutes: interval(of: .minute, from: other, calendar: calendar),
            seconds: Int(timeIntervalSinceNow - other.timeIntervalSinceNow),
            nanoseconds: interval(of: .nanosecond, from: other, calendar: calendar)
        )
    }
    
    public func to(_ other: Date, calendar: Calendar = .default) -> DateDifference {
        other.from(self, calendar: calendar)
    }
    
    public static func -(_ lhs: Date, _ rhs: Date) -> DateDifference {
        lhs.from(rhs)
    }
    
    public func adding(_ difference: DateDifference, calendar: Calendar = .default) -> Date {
        calendar.date(byAdding: difference.components, to: self) ?? addingTimeInterval(TimeInterval(difference.seconds))
    }
    
    public mutating func add(_ difference: DateDifference, calendar: Calendar = .default) {
        self = adding(difference, calendar: calendar)
    }
    
    public func adding(components: DateComponents, calendar: Calendar = .default) -> Date? {
        calendar.date(byAdding: components, to: self)
    }
    
    public func compare(with date: Date, accuracy component: Calendar.Component, calendar: Calendar = .default) -> ComparisonResult {
        calendar.compare(self, to: date, toGranularity: component)
    }
    
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
    
    public func month(in larger: Calendar.Component, calendar: Calendar = .default) -> Int { position(of: .month, in: larger, startFromZero: false, calendar: calendar) }
    public func day(in larger: Calendar.Component, calendar: Calendar = .default) -> Int { position(of: .day, in: larger, startFromZero: false, calendar: calendar) }
    public func hour(in larger: Calendar.Component, calendar: Calendar = .default) -> Int { position(of: .hour, in: larger, startFromZero: false, calendar: calendar) }
    public func minute(in larger: Calendar.Component, calendar: Calendar = .default) -> Int { position(of: .minute, in: larger, startFromZero: false, calendar: calendar) }
    public func second(in larger: Calendar.Component, calendar: Calendar = .default) -> Int { position(of: .second, in: larger, startFromZero: false, calendar: calendar) }
    public func nanosecond(in larger: Calendar.Component, calendar: Calendar = .default) -> Int { position(of: .nanosecond, in: larger, startFromZero: false, calendar: calendar) }
    public func weekday(in larger: Calendar.Component, calendar: Calendar = .default) -> Int { position(of: .weekday, in: larger, startFromZero: false, calendar: calendar) }
    public func quarter(in larger: Calendar.Component, calendar: Calendar = .default) -> Int { position(of: .quarter, in: larger, startFromZero: false, calendar: calendar) }
    public func week(in larger: Calendar.Component, calendar: Calendar = .default) -> Int { position(of: .weekOfYear, in: larger, startFromZero: false, calendar: calendar) }
    
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
}

extension Calendar.Component: CaseIterable {
    
    public static var week: Calendar.Component { .weekOfYear }
    
    public static var allCases: Set<Calendar.Component> {
        [.year, .month, .day, .hour, .minute, .second, .weekday, .weekdayOrdinal, .quarter, .weekOfMonth, .weekOfYear, .yearForWeekOfYear, .nanosecond, .calendar, .timeZone]
    }
    
    public var first: Int {
        switch self {
        case .era, .year, .month, .day, .weekday, .weekOfYear, .weekOfMonth, .weekdayOrdinal, .yearForWeekOfYear: return 1
        default: return 0
        }
    }
    
    fileprivate var smaller: Calendar.Component? {
        switch self {
        case .era:                  return .year
        case .year:                 return .month
        case .month:                return .day
        case .day:                  return .hour
        case .hour:                 return .minute
        case .minute:               return .second
        case .second:               return .nanosecond
        case .weekday:              return .hour
        case .weekdayOrdinal:       return .hour
        case .quarter:              return .month
        case .weekOfMonth:          return .day
        case .weekOfYear:           return .day
        case .yearForWeekOfYear:    return .month
        case .nanosecond:           return nil
        case .calendar:             return nil
        case .timeZone:             return nil
        @unknown default:           return nil
        }
    }
    
    fileprivate var allLarger: Set<Calendar.Component> {
        var result: Set<Calendar.Component> = []
        var current = larger
        while let component = current {
            result.insert(component)
            current = component.larger
        }
        return result
    }
    
    fileprivate var larger: Calendar.Component? {
        switch self {
        case .era:                  return nil
        case .year:                 return .era
        case .month:                return .year
        case .day:                  return .month
        case .hour:                 return .day
        case .minute:               return .hour
        case .second:               return .minute
        case .weekday:              return .day
        case .weekdayOrdinal:       return .day
        case .quarter:              return .year
        case .weekOfMonth:          return .weekOfYear
        case .weekOfYear:           return .yearForWeekOfYear
        case .yearForWeekOfYear:    return .era
        case .nanosecond:           return .second
        case .calendar:             return nil
        case .timeZone:             return nil
        @unknown default:           return nil
        }
    }
    
}

public struct DateDifference: Hashable, Equatable, ExpressibleByDictionaryLiteral {
    public var eras: Int = 0
    public var years: Int = 0
    public var quarters: Int = 0
    public var months: Int = 0
    public var weeks: Int = 0
    public var days: Int = 0
    public var hours: Int = 0
    public var minutes: Int = 0
    public var seconds: Int = 0
    public var nanoseconds: Int = 0
    
    public var components: DateComponents {
        DateComponents(era: eras, year: years, month: months, day: days, hour: hours, minute: minutes, second: seconds, nanosecond: nanoseconds, quarter: quarters, weekOfYear: weeks)
    }
    
    public init(dictionaryLiteral elements: (Calendar.Component, Int)...) {
        let dict = Dictionary(elements, uniquingKeysWith: {_, s in s})
        self = DateDifference(components: DateComponents(rawValue: dict))
    }
    
    public init(eras: Int = 0, years: Int = 0, quarters: Int = 0, months: Int = 0, weeks: Int = 0, days: Int = 0, hours: Int = 0, minutes: Int = 0, seconds: Int = 0, nanoseconds: Int = 0) {
        self.eras = eras
        self.years = years
        self.quarters = quarters
        self.months = months
        self.weeks = weeks
        self.days = days
        self.hours = hours
        self.minutes = minutes
        self.seconds = seconds
        self.nanoseconds = nanoseconds
    }
    
    public init(components: DateComponents) {
        self = DateDifference(eras: components.era ?? 0, years: components.year ?? 0, quarters: components.quarter ?? 0, months: components.month ?? 0, weeks: components.weekOfYear ?? components.weekOfMonth ?? 0, days: components.day ?? 1, hours: components.hour ?? 0, minutes: components.minute ?? 0, seconds: components.second ?? 0, nanoseconds: components.nanosecond ?? 0)
    }
    
    public static var era: DateDifference { .init(eras: 1) }
    public static var year: DateDifference { .init(years: 1) }
    public static var quarter: DateDifference { .init(quarters: 1) }
    public static var month: DateDifference { .init(months: 1) }
    public static var week: DateDifference { .init(weeks: 1) }
    public static var day: DateDifference { .init(days: 1) }
    public static var hour: DateDifference { .init(hours: 1) }
    public static var minute: DateDifference { .init(minutes: 1) }
    public static var second: DateDifference { .init(seconds: 1) }
    public static var nanosecond: DateDifference { .init(nanoseconds: 1) }
    
    public static func eras(_ value: Int) -> DateDifference { .init(eras: value) }
    public static func years(_ value: Int) -> DateDifference { .init(years: value) }
    public static func quarters(_ value: Int) -> DateDifference { .init(quarters: value) }
    public static func months(_ value: Int) -> DateDifference { .init(months: value) }
    public static func weeks(_ value: Int) -> DateDifference { .init(weeks: value) }
    public static func days(_ value: Int) -> DateDifference { .init(days: value) }
    public static func hours(_ value: Int) -> DateDifference { .init(hours: value) }
    public static func minutes(_ value: Int) -> DateDifference { .init(minutes: value) }
    public static func seconds(_ value: Int) -> DateDifference { .init(seconds: value) }
    public static func nanoseconds(_ value: Int) -> DateDifference { .init(nanoseconds: value) }
    
    public static func +(_ lhs: DateDifference, _ rhs: DateDifference) -> DateDifference {
        operation(lhs, rhs, +)
    }
    
    public static func +=(_ lhs: inout DateDifference, _ rhs: DateDifference) {
        lhs = operation(lhs, rhs, +)
    }
    
    public static func -(_ lhs: DateDifference, _ rhs: DateDifference) -> DateDifference {
        operation(lhs, rhs, -)
    }
    
    public static func -=(_ lhs: inout DateDifference, _ rhs: DateDifference) {
        lhs = lhs - rhs
    }
    
    public static func /(_ lhs: DateDifference, _ rhs: Int) -> DateDifference {
        operation(lhs, rhs, /)
    }
    
    public static func /=(_ lhs: inout DateDifference, _ rhs: Int) {
        lhs = lhs / rhs
    }
    
    public static func *(_ lhs: DateDifference, _ rhs: Int) -> DateDifference {
        operation(lhs, rhs, *)
    }
    
    public static func *(_ lhs: Int, _ rhs: DateDifference) -> DateDifference {
        rhs * lhs
    }
    
    public static func *=(_ lhs: inout DateDifference, _ rhs: Int) {
        lhs = lhs * rhs
    }
    
    fileprivate static func operation(_ lhs: DateDifference, _ rhs: DateDifference, _ block: (Int, Int) -> Int) -> DateDifference {
        DateDifference(
            eras: operation(block, lhs, rhs, at: \.eras),
            years: operation(block, lhs, rhs, at: \.years),
            quarters: operation(block, lhs, rhs, at: \.quarters),
            months: operation(block, lhs, rhs, at: \.months),
            weeks: operation(block, lhs, rhs, at: \.weeks),
            days: operation(block, lhs, rhs, at: \.days),
            hours: operation(block, lhs, rhs, at: \.hours),
            minutes: operation(block, lhs, rhs, at: \.minutes),
            seconds: operation(block, lhs, rhs, at: \.seconds),
            nanoseconds: operation(block, lhs, rhs, at: \.nanoseconds)
        )
    }
    
    fileprivate static func operation(_ lhs: DateDifference, _ rhs: Int, _ block: (Int, Int) -> Int) -> DateDifference {
        DateDifference(
            eras: operation(block, lhs, rhs, at: \.eras),
            years: operation(block, lhs, rhs, at: \.years),
            quarters: operation(block, lhs, rhs, at: \.quarters),
            months: operation(block, lhs, rhs, at: \.months),
            weeks: operation(block, lhs, rhs, at: \.weeks),
            days: operation(block, lhs, rhs, at: \.days),
            hours: operation(block, lhs, rhs, at: \.hours),
            minutes: operation(block, lhs, rhs, at: \.minutes),
            seconds: operation(block, lhs, rhs, at: \.seconds),
            nanoseconds: operation(block, lhs, rhs, at: \.nanoseconds)
        )
    }
    
    fileprivate static func operation(_ operation: (Int, Int) -> Int, _ lhs: DateDifference, _ rhs: Int, at keyPath: KeyPath<DateDifference, Int>) -> Int {
        operation(lhs[keyPath: keyPath], rhs)
    }
    
    fileprivate static func operation(_ operation: (Int, Int) -> Int, _ lhs: DateDifference, _ rhs: DateDifference, at keyPath: KeyPath<DateDifference, Int>) -> Int {
        operation(lhs[keyPath: keyPath], rhs[keyPath: keyPath])
    }
    
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

public func +(_ lhs: Date?, _ rhs: DateDifference) -> Date? {
    lhs?.adding(rhs)
}

public func -(_ lhs: Date?, _ rhs: DateDifference) -> Date? {
    lhs?.adding(-rhs)
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

extension DateInterval {
    
    public var difference: DateDifference {
        end - start
    }
    
    public func each(_ component: Calendar.Component, step: Int = 1, calendar: Calendar = .default) -> DatesCollection {
        return (start..<end).each(component, step: step, calendar: calendar)
    }
    
}

public struct DatesCollection: Collection {
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
