//
//  BudgetView.swift
//  Expense Tracker
//
//  Created by John Menaker on 12/18/21.
//

import SwiftUI
import RealmSwift

struct BudgetListView: View {
    @ObservedResults(Budget.self) var budgets
    @State var searchText: String = ""
    var searchResults: Results<Budget> {
        if searchText.isEmpty {
            return budgets
        } else {
            return budgets
                .filter("name CONTAINS[c] %@ OR ANY records.category CONTAINS[c] %@", searchText, searchText)
        }
    }

    var body: some View {
        NavigationView {
            VStack {
                SwiftUI.List {
                    ForEach(searchResults
                        .sorted(byKeyPath: "startDate", ascending: true), id: \.id) { budget in
                        NavigationLink {
                            BudgetView(budget: budget)
                        } label: {
                            Text("\(budget.name != "" ? budget.name : "New Budget")")
                            Spacer()
                            let balance = budget.calculateBalance()
                            ColoredMoney(amount: abs(balance), isRed: balance < 0.0)
                        }
                    }
                }.searchable(text: $searchText)
                .navigationTitle("Budgets")
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button(action: {
                                $budgets.append(Budget())
                            }) {
                                Text("Add New")
                            }
                        }
                    }
            }.padding(.bottom, 15)
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

// ZStack {
//    Rectangle()
//        .foregroundColor(Color("LightGray"))
//    HStack {
//        Image(systemName: "magnifyingglass")
//        TextField("Search..", text: $searchText)
//    }
//    .foregroundColor(.gray)
//    .padding(.leading, 13)
// }
