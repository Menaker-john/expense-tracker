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

    func getTitle() -> String {
        return "YOY \(showTopSavings ? "Top" : "Bottom") Savings"
    }

    func fetchData() -> [(String, Double)] {
        return BudgetsService.getThreeSavings(previous: previousYearsBudgets, current: currentYearsBudgets, showTop: showTopSavings)
    }

    var body: some View {
        VStack {
            BarChartView(data: fetchData(), formatter: .money, isHorizontal: true)
        }
        .navigationTitle(getTitle())
    }
}
