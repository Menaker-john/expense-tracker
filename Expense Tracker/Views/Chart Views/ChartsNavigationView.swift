//
//  ChartsNavigationView.swift
//  Expense Tracker
//
//  Created by John Menaker on 1/25/22.
//

import SwiftUI
import RealmSwift

struct ChartsNavigationView: View {
    @ObservedResults(Budget.self) var budgets

    var body: some View {
        NavigationView {
            List {
                NavigationLink {
                    ExpenseOverviewChart(budgets: $budgets)
                } label: {
                    Text("Expense Overview")
                }

                NavigationLink {
                    SpendingTrendsChart(budgets: $budgets)
                } label: {
                    Text("Year-to-Date Spending Trends")
                }

                NavigationLink {
                    SavingsChart(budgets: $budgets, showTopSavings: true)
                } label: {
                    Text("Top Year-Over-Year Savings")
                }

                NavigationLink {
                    SavingsChart(budgets: $budgets, showTopSavings: false)
                } label: {
                    Text("Bottom Year-Over-Year Savings")
                }
            }
            .navigationTitle("Charts")
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}

//            VStack {
//                NavigationLink {
//                    ExpenseOverviewChart(budgets: $budgets)
//                } label: {
//                    Card(title: "Expense Overview", color: .mint.opacity(0.3))
//                }.buttonStyle(PlainButtonStyle())
//
//                NavigationLink {
//                    SpendingTrendsChart(budgets: $budgets)
//                } label: {
//                    Card(title: "Year-to-Date Spending Trends", color: .pink.opacity(0.3))
//                }.buttonStyle(PlainButtonStyle())
//
//                NavigationLink {
//                    SavingsChart(budgets: $budgets, showTopSavings: true)
//                } label: {
//                    Card(title: "Top Year-Over-Year Savings", color: .cyan.opacity(0.3))
//                }.buttonStyle(PlainButtonStyle())
//
//                NavigationLink {
//                    SavingsChart(budgets: $budgets, showTopSavings: false)
//                } label: {
//                    Card(title: "Bottom Year-Over-Year Savings", color: .orange.opacity(0.3))
//                }.buttonStyle(PlainButtonStyle())
//                Spacer()
