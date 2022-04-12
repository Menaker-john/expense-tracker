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
    @StateObject var viewModel = ContentViewModel()

    var filteredResults: Results<Budget> {
        return budgets.filter("records.@count > 0")
    }

    var body: some View {
        VStack {
            if budgets.count > 0 {
                Picker("Budget", selection: $viewModel.budget) {
                    ForEach(filteredResults, id: \.self) { budget in
                        HStack {
                            BudgetName(name: budget.name, isArchived: budget.isArchived)
                        }.tag(budget as Budget?)
                    }
                }.onAppear {
                    viewModel.budget = filteredResults.first
                }
                .padding()
                .pickerStyle(MenuPickerStyle())
            } else {
                Text("Add records to a budget to use charts.")
                    .padding()
            }

            PieChartView(
                values: $viewModel.values.wrappedValue,
                names: $viewModel.names.wrappedValue,
                formatter: Formatter.money,
                widthFraction: 0.66
            )
        }
    }
}

class ContentViewModel: ObservableObject {
    @Published var names: [String] = []
    @Published var values: [Double] = []
    @Published var budget: Budget? {
        didSet {
            var categories: [String: Double] = [:]
            budget?.records.forEach { record in
                if record.isExpense && record.category != "" && record.amount > 0.0 {
                    categories[record.category] = record.amount + (categories[record.category] ?? 0.0)
                }
            }
            names = Array(categories.keys)
            values = Array(categories.values)
        }
    }
}
