//
//  YTDSpendingTrendsChart.swift
//  Expense Tracker
//
//  Created by John Menaker on 4/21/22.
//

import SwiftUI
import RealmSwift

struct YTDSpendingTrendsChart: View {
    @ObservedResults(Budget.self) var budgets

    var budgetsYTD: Results<Budget> {
        return self.budgets
            .filter("records.@count > 0 AND startDate >= %@", Date.beginningOfCurrentYear())
    }

    func fetchData() -> [(String, Double)] {
        return BudgetsService.getYTDSpending(budgets: budgetsYTD)
    }

    var body: some View {
        VStack {
            BarChartView(data: fetchData(), formatter: .money, isHorizontal: false)
        }.navigationTitle("YTD Spending Trends")
    }
}
