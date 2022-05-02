//
//  BudgetView.swift
//  Expense Tracker
//
//  Created by John Menaker on 12/18/21.
//

import SwiftUI
import RealmSwift

struct BudgetListView: View {
    @ObservedResults(Budget.self) private var budgets

    @State private var searchText: String = ""
    @State private var isSearching: Bool = false
    @State private var isEditing: Bool = false
    @State private var isShowingArchived: Bool = false

    private var searchResults: Results<Budget> {
        if searchText.isEmpty {
            return self.budgets
                .filter("isArchived = %@", isShowingArchived)
                .sorted(byKeyPath: isShowingArchived ? "startDate" : "index", ascending: true)
        } else {
            return self.budgets
                .filter("isArchived = %@", isShowingArchived)
                .filter("name CONTAINS[c] %@ OR ANY records.category CONTAINS[c] %@", searchText, searchText)
                .sorted(byKeyPath: "name", ascending: true)
        }
    }

    fileprivate func deleteBudget(offsets: IndexSet) {
        if let index = offsets.first {
            let thawedBudget = searchResults[index].thaw()
            let thawedRealm = thawedBudget!.realm!
            try! thawedRealm.write {
                if let budget = thawedBudget {
                    thawedRealm.delete(budget)
                }

                for i in index..<searchResults.count {
                    let thawedBudget = searchResults[i].thaw()
                    if let budget = thawedBudget {
                        budget.index -= 1
                    }
                }
            }
        }
    }

    fileprivate func moveBudget(source: IndexSet, destination: Int) {
        if let oldIndex = source.first, oldIndex != destination {
            var newIndex: Int
            var range: CountableRange<Int>
            var dir = 1
            if oldIndex < destination {
                dir = -1
                newIndex = destination - 1
                range = (oldIndex + 1)..<destination
            } else {
                newIndex = destination
                range = newIndex..<oldIndex
            }

            let thawedBudget = searchResults[oldIndex].thaw()
            let thawedRealm = thawedBudget!.realm!

            try! thawedRealm.write {
                if let budget = thawedBudget {
                    budget.index = newIndex
                }

                for index in range {
                    let thawedBudget = searchResults[index].thaw()
                    if let budget = thawedBudget {
                        budget.index += dir * 1
                    }
                }
            }
        }
    }

    fileprivate func onAddNew() {
        let newBudget = Budget()
        if let prevIndex = budgets.sorted(byKeyPath: "index", ascending: true).last?.index {
            newBudget.index = prevIndex + 1
        }
        $budgets.append(newBudget)
    }

    var body: some View {
        NavigationView {
            VStack {
                SearchBar(text: $searchText, isSearching: $isSearching)
                    .onTapGesture {
                        self.isSearching = true
                        self.isEditing = false
                    }
                List {
                    ForEach(searchResults, id: \.id) { budget in
                        NavigationLink {
                            BudgetView(budget: budget)
                        } label: {
                            BudgetName(name: budget.name, isArchived: budget.isArchived)
                            Spacer()
                            let balance = budget.calculateBalance()
                            ColoredMoney(amount: abs(balance), isRed: balance < 0.0)
                        }
                    }
                    .onDelete(perform: deleteBudget)
                    .onMove(perform: moveBudget)
                }
                .environment(\.editMode, .constant(isEditing ? EditMode.active : EditMode.inactive))
                .navigationTitle("Budgets")
                .toolbar {
                    ToolbarItemGroup(placement: .navigationBarTrailing) {

                        Button(action: {
                            self.isShowingArchived.toggle()
                        }) {
                            if self.isShowingArchived {
                                Text("Show Active")
                            } else {
                                Text("Show Archived")
                            }
                        }

                        Button(action: onAddNew) {
                            Text("Add New")
                        }
                        .disabled(isShowingArchived)

                        Button(action: {
                            self.isEditing.toggle()
                        }) {
                            if self.isEditing {
                                Text("Done")
                            } else {
                                Text("Edit")
                            }
                        }
                        .disabled(isSearching || isShowingArchived)
                    }
                }
            }
            .padding(.bottom, 15)
        }
        .navigationViewStyle(StackNavigationViewStyle())
    }
}
