//
//  ExpensePercentView.swift
//  Expense Tracker
//
//  Created by John Menaker on 4/18/22.
//

import SwiftUI
import RealmSwift

struct ExpensePercentView: View {
    @ObservedResults(Budget.self) var budgets
    @State var budget: Budget?
    @StateObject var viewModel = ContentViewModel()
    @State var searchText: String = ""

    var filteredResults: Results<Budget> {
        if searchText.isEmpty {
            return self.budgets
                .filter("records.@count > 0")
                .sorted(byKeyPath: "name", ascending: true)
        } else {
            return self.budgets
                .filter("records.@count > 0")
                .filter("name CONTAINS[c] %@", searchText)
                .sorted(byKeyPath: "name", ascending: true)
        }

    }

    var body: some View {
        VStack {
            Picker("Budget", selection: $budget) {
                ForEach(filteredResults, id: \.self) { budget in
                    HStack {
                        BudgetName(name: budget.name, isArchived: budget.isArchived)
                    }.tag(budget as Budget?)
                }
            }
            .searchable(text: $searchText)
//            .onAppear {
//                viewModel.budget = filteredResults.first
//            }
            .padding()
            .pickerStyle(MenuPickerStyle())
            PieChartView(
                values: (budget?.getExpenseRecordsOverZero() ?? []).reduce(into: [:]) {(result, record) in
                    result[record.category] = (result[record.category] ?? 0) + record.amount
                },
                formatter: Formatter.money,
                widthFraction: 0.66
            )
//            PieChartView(
//                values: $viewModel.values.wrappedValue,
//                names: $viewModel.names.wrappedValue,
//                formatter: Formatter.money,
//                widthFraction: 0.66
//            )
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
