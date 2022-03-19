//
//  BudgetsView.swift
//  Expense Tracker
//
//  Created by John Menaker on 3/18/22.
//

import SwiftUI
import RealmSwift

struct BudgetsView: View {
    @ObservedResults(Budgets.self) var budgetsArray

    var body: some View {
        VStack {
            if let budgets = budgetsArray.first {
                BudgetListView(budgetsArray: budgets)
            } else {
                ProgressView().onAppear {
                    $budgetsArray.append(Budgets())
                }
            }
        }
    }
}
