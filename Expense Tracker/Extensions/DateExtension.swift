//
//  DateExtension.swift
//  Expense Tracker
//
//  Created by John Menaker on 4/21/22.
//

import Foundation

extension Date {
    static func beginningOfCurrentYear() -> Date {
        var dateComponents = Calendar.current.dateComponents([.year], from: Date())
        dateComponents.day = 1
        dateComponents.month = 1

        return Calendar.current.date(from: dateComponents)!
    }

    static func endOfCurrentYear() -> Date {
        var dateComponents = Calendar.current.dateComponents([.year], from: Date())
        dateComponents.day = 31
        dateComponents.month = 12

        return Calendar.current.date(from: dateComponents)!
    }

    static func beginningOfPreviousYear() -> Date {
        var dateComponents = Calendar.current.dateComponents([.year], from: Date())
        dateComponents.day = 1
        dateComponents.month = 1
        dateComponents.year = (dateComponents.year ?? 1970) - 1

        return Calendar.current.date(from: dateComponents)!
    }

    func monthIndex() -> Int {
        return Calendar.current.component(.month, from: self) - 1
    }
}
