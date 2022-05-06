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
        return records.reduce(into: 0.0) { partialResult, record in
            if record.isExpense {
                partialResult -= record.amount
            } else {
                partialResult += record.amount
            }
        }
    }

    func calculateIncome() -> Double {
        return records.reduce(into: 0.0) { partialResult, record in
            if !record.isExpense {
                partialResult += record.amount
            }
        }
    }

    func calculateExpense() -> Double {
        return records.reduce(into: 0.0) { partialResult, record in
            if record.isExpense {
                partialResult += record.amount
            }
        }
    }

    func getExpenseRecordsOverZero() -> [Record] {
        return records.filter {
            $0.isExpense && $0.amount > 0.0
        }
    }

    func getExpenseTotalsPerCategory() -> [(String, Double)] {
        return getExpenseRecordsOverZero().map { ($0.category, $0.amount)}
    }

    func getSortedExpenseTotalsPerCategory() -> [(String, Double)] {
        let expenses = getExpenseTotalsPerCategory()
        return Dictionary(expenses, uniquingKeysWith: { $0 + $1 })
            .sorted { $0.value > $1.value }
    }

}
