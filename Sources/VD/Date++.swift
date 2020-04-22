import Foundation

extension Calendar {
    public static var `default` = Calendar.current
    
    public func current(_ component: Component) -> Int {
        self.component(component, from: Date())
    }
    
    public func name(forWeekday weekday: Int) -> String {
        standaloneWeekdaySymbols[weekday - firstWeekday]
    }
    
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

extension DateComponents {
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
    
    fileprivate static func current(timeZone: TimeZone? = .current, era: Int? = nil, year: Int? = nil, month: Int? = nil, day: Int? = nil, hour: Int? = nil, minute: Int? = nil, second: Int? = nil, nanosecond: Int? = nil, weekday: Int? = nil, weekdayOrdinal: Int? = nil, quarter: Int? = nil, weekOfMonth: Int? = nil, weekOfYear: Int? = nil, yearForWeekOfYear: Int? = nil) -> DateComponents {
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
    
}

extension Date {
    
    public static var today: Date { Date().start(of: .day) }
    public static var yesterday: Date { Date().start(of: .day) - .day }
    public static var tomorrow: Date { Date().start(of: .day) + .day }
    
    public var isToday: Bool { start(of: .day) == .today }
    public var isYesterday: Bool { start(of: .day) == .yesterday }
    public var isTomorrow: Bool { start(of: .day) == .tomorrow }
    public var isCurrentWeek: Bool { start(of: .week) == Date.today.start(of: .week) }
    
//    public enum TimeDirection {
//        case future, past, any
//    }
    
    public func components(calendar: Calendar = .default) -> DateComponents {
        calendar.dateComponents(Calendar.Component.allCases, from: self)
    }
    
    public init(era: Int = 1, year: Int, month: Int = 1, day: Int = 1, hour: Int = 0, minute: Int = 0, second: Int = 0, nanosecond: Int = 0, calendar: Calendar = .default, timeZone: TimeZone = .current) {
        self = DateComponents(calendar: calendar, timeZone: timeZone, era: era, year: year, month: month, day: day, hour: hour, minute: minute, second: second, nanosecond: nanosecond).date ?? Date()
    }
    
    public func start(of component: Calendar.Component, calendar: Calendar = .default) -> Date {
        if component == .day {
            return calendar.startOfDay(for: self)
        }
        var set = component.allLarger
        set.insert(component)
        return calendar.date(from: calendar.dateComponents(set, from: self)) ?? self
    }
    
    public func end(of component: Calendar.Component, calendar: Calendar = .default) -> Date {
        guard let next = component.smaller else { return self }
        var components = DateComponents.current()
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
    
    public func count(of smaller: Calendar.Component, in larger: Calendar.Component, calendar: Calendar = .default) -> Int {
        range(of: smaller, in: larger, calendar: calendar)?.count ?? 0
    }
    
    public static func -(_ lhs: Date, _ rhs: Date) -> DateDifference {
        lhs.from(rhs)
    }
    
    public func string(_ format: String, locale: Locale = .current, timeZone: TimeZone = .current) -> String {
        let formatter = DateFormatter()
        formatter.locale = locale
        formatter.dateFormat = format
        formatter.timeZone = .current
        return formatter.string(from: self)
    }
    
    public func position(of smaller: Calendar.Component, in larger: Calendar.Component, calendar: Calendar = .default) -> Int {
        interval(of: smaller, from: start(of: larger, calendar: calendar), calendar: calendar)
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
    
    public func adding(_ difference: DateDifference, calendar: Calendar = .default) -> Date {
        calendar.date(byAdding: difference.components, to: self) ?? addingTimeInterval(TimeInterval(difference.seconds))
    }
    
    public mutating func add(_ difference: DateDifference, calendar: Calendar = .default) {
        self = adding(difference, calendar: calendar)
    }
    
//    public func nearest(_ components: DateComponents, in time: TimeDirection = .any, matchingPolicy: Calendar.MatchingPolicy = .strict, calendar: Calendar = .default) -> Date? {
//        switch time {
//        case .future:
//            return calendar.nextDate(after: self, matching: components, matchingPolicy: matchingPolicy)
//        case .past:
//
//        case .any:
//        }
//    }
    
    public func month(in larger: Calendar.Component, calendar: Calendar = .default) -> Int { position(of: .month, in: larger, calendar: calendar) }
    public func day(in larger: Calendar.Component, calendar: Calendar = .default) -> Int { position(of: .day, in: larger, calendar: calendar) }
    public func hour(in larger: Calendar.Component, calendar: Calendar = .default) -> Int { position(of: .hour, in: larger, calendar: calendar) }
    public func minute(in larger: Calendar.Component, calendar: Calendar = .default) -> Int { position(of: .minute, in: larger, calendar: calendar) }
    public func second(in larger: Calendar.Component, calendar: Calendar = .default) -> Int { position(of: .second, in: larger, calendar: calendar) }
    public func nanosecond(in larger: Calendar.Component, calendar: Calendar = .default) -> Int { position(of: .nanosecond, in: larger, calendar: calendar) }
    public func weekday(in larger: Calendar.Component, calendar: Calendar = .default) -> Int { position(of: .weekday, in: larger, calendar: calendar) }
    public func quarter(in larger: Calendar.Component, calendar: Calendar = .default) -> Int { position(of: .quarter, in: larger, calendar: calendar) }
    public func week(in larger: Calendar.Component, calendar: Calendar = .default) -> Int { position(of: .weekOfYear, in: larger, calendar: calendar) }
    
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
    
    fileprivate var allSmaller: Set<Calendar.Component> {
        var result: Set<Calendar.Component> = []
        var current = smaller
        while let component = current {
            result.insert(component)
            current = component.smaller
        }
        return result
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

public struct DateDifference: Hashable, Equatable {
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
        locale = .current
    }
    
}

