//
//  YOYTopSavings.swift
//  Expense Tracker
//
//  Created by John Menaker on 4/22/22.
//

import SwiftUI
import RealmSwift

struct YOYTopSavings: View {
    @ObservedResults(Budget.self) var budgets
    var names: [String] = []
    var values: [Double] = []

    init(budgets: ObservedResults<Budget>) {

        let previousYearsData = calculateTotals(previousYearsBudgets)
        let currentYearsData = calculateTotals(currentYearsBudgets)
        let savings = calculateSavings(previous: previousYearsData, current: currentYearsData)
        let top = topSavings(savings)

        for i in 0..<top.count {
            names.append(top[i].0)
            values.append(top[i].1)
        }
    }

    fileprivate func calculateTotals(_ budgets: Results<Budget>) -> [String: Double] {
        let keyValuePairs = budgets.reduce(into: []) { results, budget in
            results.append(contentsOf: budget.getExpenseTotalsPerCategoryKVP())
        }
        return Dictionary(keyValuePairs, uniquingKeysWith: { $0 + $1 })
    }

    fileprivate func calculateSavings(previous: [String: Double], current: [String: Double]) -> [String: Double] {
        var data: [String: Double] = [:]
        for (key, value) in previous {
            data[key] = abs((current[key] ?? 0.0) - value)
        }
        return data
    }

    fileprivate func topSavings(_ savings: [String: Double]) -> [(String, Double)] {
        return Array(savings.sorted { $0.value > $1.value }.filter { (_: String, value: Double) in
            value > 0
        }.prefix(3))
    }

    var previousYearsBudgets: Results<Budget> {
        let start = Date.beginningOfPreviousYear()
        let end = Date.beginningOfCurrentYear()
        return self.budgets
            .filter("records.@count > 0 AND startDate >= %@ AND startDate < %@", start, end)
    }

    var currentYearsBudgets: Results<Budget> {
        let start = Date.beginningOfCurrentYear()
        let end = Date.endOfCurrentYear()
        return self.budgets
            .filter("records.@count > 0 AND startDate >= %@ AND startDate <= %@", start, end)
    }

    var body: some View {
        VStack {
            BarChartView(names: names, values: values, formatter: .money, isHorizontal: true)
        }
        .navigationTitle("YOY Top Savings")
    }
}
