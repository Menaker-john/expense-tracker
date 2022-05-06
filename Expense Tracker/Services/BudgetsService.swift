//
//  BudgetsService.swift
//  Expense Tracker
//
//  Created by John Menaker on 4/25/22.
//
import Foundation
import RealmSwift

struct BudgetsService {

    static fileprivate func calculateTotals(_ budgets: Results<Budget>) -> [String: Double] {
        let expenses = budgets.reduce(into: []) { results, budget in
            results.append(contentsOf: budget.getExpenseTotalsPerCategory())
        }
        return Dictionary(expenses, uniquingKeysWith: { $0 + $1 })
    }

    static fileprivate func calculateDifference(lhs: [String: Double], rhs: [String: Double]) -> [String: Double] {
        var data: [String: Double] = [:]
        var keys = Array(rhs.keys)
        keys.append(contentsOf: lhs.keys)

        for key in Set(keys) {
            data[key] = (rhs[key] ?? 0.0) - (lhs[key] ?? 0.0)
        }
        return data
    }

    static fileprivate func sortDifferences(_ differences: [String: Double]) -> [(String, Double)] {
        return differences.filter { (_: String, value: Double) in
            abs(value) > 0
        }.sorted { $0.value < $1.value }
    }

    static fileprivate func getSortedSavings(previous: Results<Budget>, current: Results<Budget>) -> [(String, Double)] {
        let previousYearsData = calculateTotals(previous)
        let currentYearsData = calculateTotals(current)
        let savings = calculateDifference(lhs: previousYearsData, rhs: currentYearsData)
        return sortDifferences(savings)
    }

    static fileprivate func getTopSavings(previous: Results<Budget>, current: Results<Budget>) -> [(String, Double)] {
        return Array(getSortedSavings(previous: previous, current: current).prefix(5))
    }

    static fileprivate func getBottomSavings(previous: Results<Budget>, current: Results<Budget>) -> [(String, Double)] {
        return Array(getSortedSavings(previous: previous, current: current).suffix(5))
    }

    static func getSavings(previous: Results<Budget>, current: Results<Budget>, showTopSavings: Bool) -> [(String, Double)] {
        if showTopSavings {
            return getTopSavings(previous: previous, current: current)
        } else {
            return getBottomSavings(previous: previous, current: current)
        }
    }

    static func getSpendingTrends(budgets: Results<Budget>) -> [(String, Double)] {
        let currentMonth = Date().monthIndex() + 1
        var values: [Double] = Array(repeating: 0.0, count: currentMonth)

        for budget in budgets {
            for record in budget.records {
                let month = record.date.monthIndex()
                if record.isExpense && month < currentMonth {
                    values[month] = values[month] + record.amount
                }
            }
        }
        return zip(Calendar.current.shortMonthSymbols, values).map { ($0, $1) }
    }

}
