//
//  SpendingTrendsChart.swift
//  Expense Tracker
//
//  Created by John Menaker on 4/21/22.
//

import SwiftUI
import RealmSwift

struct SpendingTrendsChart: View {
    @ObservedResults(Budget.self) var budgets

    var budgetsYTD: Results<Budget> {
        return self.budgets
            .filter("records.@count > 0")
            .filter("startDate >= %@", Date.beginningOfCurrentYear())
            .filter("startDate <= %@", Date.endOfCurrentYear())
    }

    func fetchData() -> [(String, Double)] {
        return BudgetsService.getSpendingTrends(budgets: budgetsYTD)
    }

    var body: some View {
        VStack {
            VBarChartView(data: fetchData(), formatter: .intMoney)
        }.navigationTitle("YTD Spending Trends")
    }
}
