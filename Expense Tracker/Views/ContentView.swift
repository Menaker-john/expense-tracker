//
//  ContentView.swift
//  Expense Tracker
//
//  Created by John Menaker on 12/18/21.
//

import SwiftUI
import RealmSwift

struct ContentView: View {

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
            BudgetListView()
                .tabItem {
                    Label("Budgets", systemImage: "chart.bar.doc.horizontal")
                }
            ChartsNavigationView()
                .tabItem {
                    Label("Charts", systemImage: "chart.pie")
                }
        }
    }
}
