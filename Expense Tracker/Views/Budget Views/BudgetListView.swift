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
        let filteredBudgets = self.budgets.filter("isArchived = %@", isShowingArchived)

        if searchText.isEmpty {
            return filteredBudgets
                .sorted(byKeyPath: isShowingArchived ? "startDate" : "index", ascending: true)
        } else {
            return filteredBudgets
                .filter("name CONTAINS[c] %@ OR ANY records.category CONTAINS[c] %@", searchText, searchText)
                .sorted(byKeyPath: "name", ascending: true)
        }
    }

    fileprivate func shiftIndexValuesDown(_ index: Int) {
        for i in index..<searchResults.count {
            let thawedBudget = searchResults[i].thaw()

            if let budget = thawedBudget {
                budget.index -= 1
            }
        }
    }

    fileprivate func deleteBudget(_ index: Int) {
        guard index < searchResults.count else { return }

        let thawedBudget = searchResults[index].thaw()
        let thawedRealm = thawedBudget!.realm!

        try! thawedRealm.write {
            if let budget = thawedBudget {
                thawedRealm.delete(budget)
            }

            shiftIndexValuesDown(index)
        }
    }

    fileprivate func archiveBudget(_ index: Int) {
        guard index < searchResults.count else { return }

        let thawedBudget = searchResults[index].thaw()
        let thawedRealm = thawedBudget!.realm!

        try! thawedRealm.write {
            if let budget = thawedBudget {
                budget.isArchived = true
            }

            shiftIndexValuesDown(index)
        }
    }

    fileprivate func restoreBudget(_ index: Int) {
        guard index < searchResults.count else { return }

        let thawedBudget = searchResults[index].thaw()
        let thawedRealm = thawedBudget!.realm!

        let newIndex = thawedRealm.objects(Budget.self)
            .filter("isArchived == false").count

        try! thawedRealm.write {
            if let budget = thawedBudget {
                budget.isArchived = false
                budget.index = newIndex
            }
        }
    }

    fileprivate func moveBudget(source: IndexSet, destination: Int) {
        guard let oldIndex = source.first, oldIndex != destination else { return }

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

    fileprivate func onAddNew() {
        let newBudget = Budget()
        if let prevIndex = budgets.sorted(byKeyPath: "index", ascending: true).last?.index {
            newBudget.index = prevIndex + 1
        }
        $budgets.append(newBudget)
    }

    var body: some View {
        GeometryReader { _ in
            NavigationView {
                ZStack {
                    VStack {
                        SearchBar(text: $searchText, isSearching: $isSearching)
                            .onTapGesture {
                                self.isSearching = true
                                self.isEditing = false
                            }
                        List {
                            ForEach(Array(searchResults.enumerated()), id: \.offset) { index, budget in
                                NavigationLink {
                                    BudgetView(budget: budget)
                                } label: {
                                    BudgetName(name: budget.name, isArchived: budget.isArchived)
                                    Spacer()
                                    let balance = budget.calculateBalance()
                                    ColoredMoney(amount: abs(balance), isRed: balance < 0.0)
                                }
                                .swipeActions(edge: .leading) {
                                    if budget.isArchived {
                                        Button("Restore") {
                                            restoreBudget(index)
                                        }
                                    } else {
                                        Button("Archive") {
                                            archiveBudget(index)
                                        }
                                    }
                                }
                                .swipeActions(edge: .trailing) {
                                    Button("Delete", role: .destructive) {
                                        deleteBudget(index)
                                    }
                                }
                            }
                            .onMove(perform: moveBudget)
                        }
                        .environment(\.editMode, .constant(isEditing ? EditMode.active : EditMode.inactive))
                        .navigationTitle("Budgets")
                        .toolbar {
                            ToolbarItemGroup(placement: .navigationBarTrailing) {

                                Button(action: {
                                    isShowingArchived.toggle()
                                }) {
                                    isShowingArchived ? Text("Show Active") : Text("Show Archived")
                                }.disabled(isEditing)

                                Button(action: {
                                    isEditing.toggle()
                                }) {
                                    isEditing ? Text("Done") : Text("Sort")
                                }
                                .disabled(isSearching || isShowingArchived)
                            }
                        }
                    }
                    VStack {
                        Spacer()

                        Button(action: onAddNew) {
                            Text("+")
                                .font(.title)
                                .padding()
                                .background(Color.blue.opacity(0.7))
                                .clipShape(Circle())
                        }
                        .shadow(color: Color.black.opacity(0.3), radius: 3, x: 3, y: 3)
                        .buttonStyle(PlainButtonStyle())
                        .disabled(isShowingArchived)
                    }
                }
            }
            .navigationViewStyle(StackNavigationViewStyle())
        }
    }
}
