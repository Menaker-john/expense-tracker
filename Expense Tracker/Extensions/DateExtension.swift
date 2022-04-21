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
//        dateComponents.second = 1
//        dateComponents.minute = 1
//        dateComponents.hour = 1
        dateComponents.day = 1
        dateComponents.month = 1

        return Calendar.current.date(from: dateComponents)!
    }

    func monthIndex() -> Int {
        return Calendar.current.component(.month, from: self) - 1
    }
}
