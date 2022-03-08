//
//  ChartsView.swift
//  Expense Tracker
//
//  Created by John Menaker on 1/25/22.
//

import SwiftUI
import RealmSwift

class ContentViewModel: ObservableObject {
    @Published var names: [String] = []
    @Published var values: [Double] = []
    @Published var budget: Budget? {
        didSet {
            var categories: [String: Double] = [:]
            budget?.records.forEach { record in
                if record.isExpense && record.category != "" && (record.amount ?? 0) > 0.0 {
                    categories[record.category] = (record.amount ?? 0) + (categories[record.category] ?? 0)
                }
            }
            names = Array(categories.keys)
            values = Array(categories.values)
        }
    }
}

struct ChartsView: View {
    @ObservedResults(Budgets.self) var budgetsArray
    @ObservedObject var viewModel = ContentViewModel()

    var body: some View {
        VStack {
            if let firstBudget = budgetsArray.first {
                let budgets = Array(firstBudget.budgets.filter { ($0 as Budget).isAdvanced })
                if budgets.count > 0 {
                    Picker("Budget", selection: $viewModel.budget) {
                        ForEach(budgets, id: \.self) { budget in
                            HStack {
                                Text(budget.name)
                            }.tag(budget as Budget?)
                        }
                    }.onAppear {
                        if viewModel.budget == nil {
                            viewModel.budget = budgets.first
                        }
                    }
                    .padding()
                    .pickerStyle(MenuPickerStyle())
                } else {
                    Text("No Advanced Budgets")
                        .padding()
                }
            }
            PieChartView(
                values: $viewModel.values.wrappedValue,
                names: $viewModel.names.wrappedValue,
                formatter: Formatter.money,
                widthFraction: 0.50
            )
        }
    }
}
