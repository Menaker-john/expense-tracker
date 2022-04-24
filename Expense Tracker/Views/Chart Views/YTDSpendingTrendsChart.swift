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

    var months: [String] = ["Jan", "Feb", "Mar", "Apr", "May", "Jun", "Jul", "Aug", "Sep", "Oct", "Nov", "Dec"]

    var data: [Double] {
        let date = Date.beginningOfCurrentYear()
        let budgetsYTD = self.budgets
            .filter("records.@count > 0 AND startDate >= %@", date)

        let currentMonth = Date().monthIndex()
        var values: [Double] = Array(repeating: 0.0, count: currentMonth + 1)

        for budget in budgetsYTD {
            for record in budget.records {
                let month = record.date.monthIndex()
                if record.isExpense && month <= currentMonth {
                    values[month] = values[month] + record.amount
                }
            }
        }

        return values
    }

    var body: some View {
        VStack {
            BarChartView(names: months, values: self.data, formatter: .money)
        }.navigationTitle("YTD Spending Trends")
    }
}
