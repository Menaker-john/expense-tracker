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
    @Persisted var name: String = ""
    @Persisted var date: Date = Date()
    @Persisted var category: String = "Expense"
    @Persisted var isExpense: Bool = true
    @Persisted var notes: String = ""
    @Persisted var amount: Double = 0.0

    convenience init(isExpense: Bool) {
        self.init()
        self.id = ObjectId.generate()
        self.isExpense = isExpense
        if !isExpense {
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
        self.notes = current.notes
    }
}
