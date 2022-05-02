//
//  ChartsView.swift
//  Expense Tracker
//
//  Created by John Menaker on 1/25/22.
//

import SwiftUI
import RealmSwift

struct ChartsView: View {
    @ObservedResults(Budget.self) var budgets

    var body: some View {
        NavigationView {
            VStack {
                NavigationLink {
                    ExpenseOverviewChart(budgets: $budgets)
                } label: {
                    Card(title: "Expense Overview", color: .mint.opacity(0.3))
                }.buttonStyle(PlainButtonStyle())

                NavigationLink {
                    YTDSpendingTrendsChart(budgets: $budgets)
                } label: {
                    Card(title: "Year-to-Date Spending Trends", color: .pink.opacity(0.3))
                }.buttonStyle(PlainButtonStyle())

                NavigationLink {
                    YOYSavings(budgets: $budgets, showTopSavings: true)
                } label: {
                    Card(title: "Top Year-Over-Year Savings", color: .cyan.opacity(0.3))
                }.buttonStyle(PlainButtonStyle())

                NavigationLink {
                    YOYSavings(budgets: $budgets, showTopSavings: false)
                } label: {
                    Card(title: "Bottom Year-Over-Year Savings", color: .orange.opacity(0.3))
                }.buttonStyle(PlainButtonStyle())
                Spacer()
            }
            .navigationTitle("Charts")
            .padding()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
