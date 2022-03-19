//
//  Budget.swift
//  Expense Tracker
//
//  Created by John Menaker on 12/22/21.
//

import Foundation
import RealmSwift

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

    func addRecord(newRecord: Record) {

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
