//
//  ExpensePercentView.swift
//  Expense Tracker
//
//  Created by John Menaker on 4/18/22.
//

import SwiftUI
import RealmSwift

struct ExpenseOverviewChart: View {
    @ObservedResults(Budget.self) var budgets
    @State var searchText: String = ""
    @State var isSearching: Bool = false

    var searchResults: Results<Budget> {
        if searchText.isEmpty {
            return self.budgets
                .filter("ANY records.isExpense == true")
                .sorted(byKeyPath: "name", ascending: true)
        } else {
            return self.budgets
                .filter("ANY records.isExpense == true")
                .filter("name CONTAINS[c] %@", searchText)
                .sorted(byKeyPath: "name", ascending: true)
        }
    }

    var body: some View {
        VStack {
            SearchBar(text: $searchText, isSearching: $isSearching)
                .onTapGesture {
                    self.isSearching = true
                }
            List {
                ForEach(searchResults, id: \.id) { budget in
                    let data = budget.getSortedExpenseTotalsPerCategory()
                    NavigationLink {
                        PieChartView(
                            names: data.map { $0.0},
                            values: data.map { $0.1},
                            formatter: .money
                        )
                        .padding()
                        .navigationBarTitleDisplayMode(.inline)
                        .navigationTitle(Text(budget.name))
                    } label: {
                        BudgetName(name: budget.name, isArchived: budget.isArchived)
                    }
                }
            }
        }
        .navigationTitle("Expense Overview")
    }
}
