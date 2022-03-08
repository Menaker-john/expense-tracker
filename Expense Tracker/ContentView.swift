//
//  ContentView.swift
//  Expense Tracker
//
//  Created by John Menaker on 12/18/21.
//

import SwiftUI
import RealmSwift

struct ContentView: View {
    @ObservedResults(Budgets.self) var budgetsArray
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    init() {
        print(getDocumentsDirectory())
    }

    var body: some View {
        TabView {
            BudgetsView(budgetsArray: $budgetsArray)
                .tabItem {
                    Label("Budgets", systemImage: "chart.bar.doc.horizontal")
                }
            ChartsView()
                .tabItem {
                    Label("Charts", systemImage: "chart.pie")
                }

        }

    }
}

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
