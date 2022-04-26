//
//  BudgetsService.swift
//  Expense Tracker
//
//  Created by John Menaker on 4/25/22.
//

import RealmSwift

struct BudgetsService {

    static func calculateTotals(_ budgets: Results<Budget>) -> [String: Double] {
        let keyValuePairs = budgets.reduce(into: []) { results, budget in
            results.append(contentsOf: budget.getExpenseTotalsPerCategoryKVP())
        }
        return Dictionary(keyValuePairs, uniquingKeysWith: { $0 + $1 })
    }

    static func calculateDifference(lhs: [String: Double], rhs: [String: Double]) -> [String: Double] {
        var data: [String: Double] = [:]
        var keys = Array(lhs.keys)
        keys.append(contentsOf: rhs.keys)

        for key in Set(keys) {
            data[key] = (rhs[key] ?? 0.0) - (lhs[key] ?? 0.0)
        }

//        for (key, value) in lhs {
//            data[key] = (rhs[key] ?? 0.0) - value
//        }
        return data
    }

    static func sortDifferences(_ differences: [String: Double]) -> [(String, Double)] {
        return differences.sorted { $0.value < $1.value }.filter { (_: String, value: Double) in
            abs(value) > 0
        }
    }

    static func getSortedSavings(previous: Results<Budget>, current: Results<Budget>) -> [(String, Double)] {
        let previousYearsData = calculateTotals(previous)
        let currentYearsData = calculateTotals(current)
        let savings = calculateDifference(lhs: previousYearsData, rhs: currentYearsData)
        return sortDifferences(savings)
    }

    static func getSavings(previous: Results<Budget>, current: Results<Budget>) -> [String: Double] {
        let previousYearsData = calculateTotals(previous)
        let currentYearsData = calculateTotals(current)
        return calculateDifference(lhs: previousYearsData, rhs: currentYearsData)
    }

    static func getTopThreeSavings(previous: Results<Budget>, current: Results<Budget>) -> [(String, Double)] {
        return Array(getSortedSavings(previous: previous, current: current).prefix(3))
    }

    static func getBottomThreeSavings(previous: Results<Budget>, current: Results<Budget>) -> [(String, Double)] {
        return Array(getSortedSavings(previous: previous, current: current).suffix(3))
    }

}
