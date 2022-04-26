//
//  YOYTopSavings.swift
//  Expense Tracker
//
//  Created by John Menaker on 4/22/22.
//

import SwiftUI
import RealmSwift

struct YOYSavings: View {
    @ObservedResults(Budget.self) var budgets
    var showTopSavings: Bool

    var names: [String] {
        let savings = getSavings()
        return getNames(savings: savings)
    }
    var values: [Double] {
        let savings = getSavings()
        return getValues(savings: savings)
    }

    func getSavings() -> [(String, Double)] {
        var savings: [(String, Double)]

        if showTopSavings {
            savings = BudgetsService.getTopThreeSavings(previous: previousYearsBudgets, current: currentYearsBudgets)
        } else {
            savings = BudgetsService.getBottomThreeSavings(previous: previousYearsBudgets, current: currentYearsBudgets)
        }

        return savings
    }

    func getNames(savings: [(String, Double)]) -> [String] {
        var names: [String] = []
        for i in 0..<savings.count {
            names.append(savings[i].0)
        }
        return names
    }

    func getValues(savings: [(String, Double)]) -> [Double] {
        var values: [Double] = []
        for i in 0..<savings.count {
            values.append(savings[i].1)
        }
        return values
    }

    func getTitle() -> String {
        return "YOY \(showTopSavings ? "Top" : "Bottom") Savings"
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
        .navigationTitle(getTitle())
    }
}
