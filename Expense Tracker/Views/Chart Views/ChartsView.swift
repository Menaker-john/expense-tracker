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
                HStack {
                    NavigationLink {
                        ExpenseOverviewChart(budgets: $budgets)
                    } label: {
                        Card(title: "Expense Overview")
                    }

                    NavigationLink {
                        YTDSpendingTrendsChart(budgets: $budgets)
                    } label: {
                        Card(title: "YTD Spending Trends")
                    }
                }
                HStack {
                    NavigationLink {
                        ExpenseOverviewChart(budgets: $budgets)
                    } label: {
                        Card(title: "Year Over Year ")
                    }
                    NavigationLink {
                        ExpenseOverviewChart(budgets: $budgets)
                    } label: {
                        Card(title: "Expense Overview")
                    }
                }
                HStack {
                    NavigationLink {
                        YOYTopSavings(budgets: $budgets)
                    } label: {
                        Card(title: "Top YoY Savings")
                    }
                    NavigationLink {
                        ExpenseOverviewChart(budgets: $budgets)
                    } label: {
                        Card(title: "Bottom YoY Savings")
                    }
                }
                Spacer()
            }
            .navigationTitle("Charts")
            .padding()
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
