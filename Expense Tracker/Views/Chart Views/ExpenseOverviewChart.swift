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
            SearchBar(text: $searchText, isSearching: $isSearching)
                .onTapGesture {
                    self.isSearching = true
                }
            List {
                ForEach(searchResults, id: \.id) { budget in
                    NavigationLink {
                        PieChartView(
                            values: budget.getExpenseTotalsPerCategory(),
                            formatter: Formatter.money
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
