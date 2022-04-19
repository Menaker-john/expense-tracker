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
                        ExpensePercentView(budgets: $budgets)
                    } label: {
                        Card(title: "Expense Overview")
                    }

                    NavigationLink {
                        ExpensePercentView(budgets: $budgets)
                    } label: {
                        Card(title: "YTD Spending Trends")
                    }
                }
                HStack {
                    NavigationLink {
                        ExpensePercentView(budgets: $budgets)
                    } label: {
                        Card(title: "Year Over Year ")
                    }
                    NavigationLink {
                        ExpensePercentView(budgets: $budgets)
                    } label: {
                        Card(title: "Expense Overview")
                    }
                }
                HStack {
                    NavigationLink {
                        ExpensePercentView(budgets: $budgets)
                    } label: {
                        Card(title: "Expense Overview")
                    }
                    NavigationLink {
                        ExpensePercentView(budgets: $budgets)
                    } label: {
                        Card(title: "Expense Overview")
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
