//
//  BudgetOptionsView.swift
//  Expense Tracker
//
//  Created by John Menaker on 3/18/22.
//

import SwiftUI
import RealmSwift

struct BudgetOptionsView: View {
    @ObservedRealmObject var budget: Budget
    var body: some View {
        Form {
            Section(header: Text("About")) {
                HStack {
                    Text("Name")
                        .frame(width: 100, alignment: .leading)
                    TextField("", text: $budget.name)
                }
                Toggle("Advanced Budget", isOn: $budget.isAdvanced)
            }

            Section(header: Text("Date Range")) {
                DatePicker("Start Date", selection: $budget.startDate, displayedComponents: [.date])
                DatePicker("End Date", selection: $budget.endDate, displayedComponents: [.date])
            }
        }
    }
}
