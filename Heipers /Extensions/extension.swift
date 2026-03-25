//
//  extension.swift
//  Plateh.th
//
//  Created by Adis on 19.03.2026.
//


import Foundation
extension Date {
    private static let turkishMonthYearFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "LLLL yyyy"
        return formatter
    }()

    private static let dayMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "dd.MM"
        return formatter
    }()

    private static let shortDisplayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "tr_TR")
        formatter.dateFormat = "d MMM"
        return formatter
    }()

    private static let isoFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        return formatter
    }()

    var startOfMonth: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: self)
        return calendar.date(from: components)!
    }
    
    var endOfMonth: Date {
        let calendar = Calendar.current
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return calendar.date(byAdding: components, to: self.startOfMonth)!
    }

    var previousMonth: Date {
        Calendar.current.date(byAdding: .month, value: -1, to: self) ?? self
    }

    var dayNumber: Int {
        Calendar.current.component(.day, from: self)
    }
    
    
    
        var withoutDayMonthYear: String {
            Date.turkishMonthYearFormatter.string(from: self).capitalized(with: Locale(identifier: "tr_TR"))
        }
    
    
    func IsInSameManth(date: Date) -> Bool { 
        let calendar = Calendar.current
        return calendar.component(.month, from: self) == calendar.component(.month, from: date)   && 
        calendar.component(.year, from: self) == calendar.component(.year, from: date)
    }
    
    var dayMonthString: String { 
        Date.dayMonthFormatter.string(from: self)
    }

    var shortTurkishDisplay: String {
        Date.shortDisplayFormatter.string(from: self)
    }

    static func fromISO8601(_ value: String?) -> Date? {
        guard let value, !value.isEmpty else { return nil }
        return isoFormatter.date(from: value)
    }
    
    }
