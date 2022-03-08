//
//  BudgetView.swift
//  Expense Tracker
//
//  Created by John Menaker on 12/18/21.
//

import SwiftUI
import RealmSwift

struct BudgetListView: View {
    @ObservedRealmObject var budgetsArray: Budgets
    @State var searchText: String = ""

    var body: some View {
        VStack {
            NavigationView {
                SwiftUI.List {
                    ForEach(budgetsArray.budgets, id: \.id) { budget in
                        NavigationLink {
                            BudgetView(budget: budget)
                        } label: {
                            Text("\(budget.name)")
                            Spacer()
                            let balance = budget.calculateBalance()
                            ColoredMoney(amount: abs(balance), isRed: balance < 0.0)
                        }
                    }.onDelete(perform: $budgetsArray.budgets.remove)
                        .onMove(perform: $budgetsArray.budgets.move)
                }.navigationTitle("Budgets")
                    .toolbar {
                        ToolbarItemGroup(placement: .navigationBarTrailing) {
                            Button(action: {
                                $budgetsArray.budgets.append(Budget())
                            }) {
                                Text("Add New")
                            }
                            EditButton()
                        }
                    }
            }.navigationViewStyle(StackNavigationViewStyle())
        }.padding(.bottom, 15)
    }
}
