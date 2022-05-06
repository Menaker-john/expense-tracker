//
//  Record.swift
//  Expense Tracker
//
//  Created by John Menaker on 3/18/22.
//

import Foundation
import RealmSwift

final class Record: EmbeddedObject, ObjectKeyIdentifiable {
    @Persisted var id: ObjectId
    @Persisted var name: String
    @Persisted var date: Date
    @Persisted var category: String
    @Persisted var isExpense: Bool
    @Persisted var amount: Double

    convenience init(isExpense: Bool, date: Date = Date()) {
        self.init()
        self.id = ObjectId.generate()
        self.name = ""
        self.date = date
        self.amount = 0.0
        self.isExpense = isExpense
        if isExpense {
            self.category = "Expense"
        } else {
            self.category = "Income"
        }
    }

    convenience init(_ current: Record) {
        self.init()
        self.id = ObjectId.generate()
        self.name = current.name
        self.amount = current.amount
        self.date = current.date
        self.category = current.category
        self.isExpense = current.isExpense
    }
}
