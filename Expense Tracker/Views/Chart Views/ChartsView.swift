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
                        YOYSavings(budgets: $budgets, showTopSavings: true)
                    } label: {
                        Card(title: "Top 3 YoY Savings")
                    }
                    NavigationLink {
                        YOYSavings(budgets: $budgets, showTopSavings: false)
                    } label: {
                        Card(title: "Bottom 3 YoY Savings")
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
