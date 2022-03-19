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

#if DEBUG
    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }

    init() {
        print(getDocumentsDirectory())
    }
#endif

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
