//
//  Budget.swift
//  Expense Tracker
//
//  Created by John Menaker on 12/22/21.
//

import Foundation
import RealmSwift

final class Budget: Object, ObjectKeyIdentifiable {
    @Persisted(primaryKey: true) var id: ObjectId
    @Persisted var name: String = ""
    @Persisted var records: List<Record>
    @Persisted var startDate: Date = Date()
    @Persisted var endDate: Date = Date()
    @Persisted var isAdvanced: Bool = false
    @Persisted var isArchived: Bool = false
    @Persisted var index: Int = 0

    override init() {
        super.init()
        self.id = ObjectId.generate()
        self.records = List<Record>()
    }

    func calculateBalance() -> Double {
        var total = 0.0
        for record in self.records {
            if record.isExpense {
                total -= record.amount
            } else {
                total += record.amount
            }
        }
        return total
    }

    func getExpenseRecordsOverZero() -> [Record] {
        return records.filter {
            $0.isExpense && $0.amount > 0.0
        }
    }

    func getExpenseTotalsPerCategory() -> [String: Double] {
        getExpenseRecordsOverZero().reduce(into: [:]) {(result, record) in
            result[record.category] = (result[record.category] ?? 0) + record.amount
        }
    }

}
