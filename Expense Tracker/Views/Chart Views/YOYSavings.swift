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
    var names: [String] = []
    var values: [Double] = []
    var showTopSavings: Bool

    init(budgets: ObservedResults<Budget>, showTopSavings: Bool) {
        self.showTopSavings = showTopSavings

        let savings = getSavings()
        splitSavings(savings: savings)
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

    mutating func splitSavings(savings: [(String, Double)]) {
        for i in 0..<savings.count {
            names.append(savings[i].0)
            values.append(savings[i].1)
        }
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
