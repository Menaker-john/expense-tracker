//
//  Budget.swift
//  Expense Tracker
//
//  Created by John Menaker on 12/22/21.
//

import Foundation
import RealmSwift

final class Budgets: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var budgets: List<Budget>

    override init() {
        super.init()
        self.id = ObjectId.generate()
        self.budgets = List<Budget>()
    }
}

final class Budget: EmbeddedObject, ObjectKeyIdentifiable {
    @Persisted var id: ObjectId
    @Persisted var name: String = "New Budget"
    @Persisted var records: List<Record>
    @Persisted var startDate: Date = Date()
    @Persisted var endDate: Date = Date()
    @Persisted var isAdvanced: Bool = false

    override init() {
        super.init()
        self.id = ObjectId.generate()
        self.records = List<Record>()
    }

    func calculateBalance() -> Double {
        var total = 0.0
        for record in self.records {
            if record.isExpense {
                total -= record.amount ?? 0
            } else {
                total += record.amount ?? 0
            }
        }
        return total
    }

}

final class Record: EmbeddedObject, ObjectKeyIdentifiable {
    @Persisted var id: ObjectId
    @Persisted var name: String = "New Record"
    @Persisted var amount: Double?
    @Persisted var date: Date = Date()
    @Persisted var category: String = "Expense"
    @Persisted var isExpense: Bool = true
    @Persisted var notes: String = ""

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
