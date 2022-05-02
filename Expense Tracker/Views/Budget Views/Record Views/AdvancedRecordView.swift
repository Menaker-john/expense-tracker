//
//  AdvancedRecordRowView.swift
//  Expense Tracker
//
//  Created by John Menaker on 3/18/22.
//

import SwiftUI
import RealmSwift

struct AdvancedRecordView: View {
    @ObservedRealmObject var record: Record
    let dateRange: ClosedRange<Date>
    let onDuplicate: () -> Void

    var body: some View {
        Form {
            Section(header: Text("About")) {
                HStack {
                    Text("Name")
                        .frame(width: 100, alignment: .leading)
                    TextField("New Record", text: $record.name)

                }
                HStack {
                    Text("Amount")
                        .frame(width: 100, alignment: .leading)
                    TextField("0", value: $record.amount, formatter: Formatter.decimal)
                        .keyboardType(.decimalPad)
                }

                DatePicker("Date",
                           selection: $record.date,
//                           in: dateRange,
                           displayedComponents: [.date]
                )

                HStack {
                    Text("Category")
                    Spacer()
                    if record.isExpense {
                        Picker("Category", selection: $record.category) {
                            ForEach(Array(Categories.keys.sorted(by: <)), id: \.self) { key in
                                HStack {
                                    if let category = Categories[key] {
                                        Image(systemName: category.image)
                                    }
                                    Text(key)
                                }.tag(key)
                            }
                        }.pickerStyle(MenuPickerStyle())
                    } else {
                        Image(systemName: "dollarsign.circle")
                        Text("Income")
                    }

                }

                VStack(alignment: .leading) {
                    Text("Description")
                    TextField("", text: $record.notes)
                }
            }

            Button(action: onDuplicate) {
                Text("Duplicate")
            }

        }.navigationTitle("Record")
    }
}
