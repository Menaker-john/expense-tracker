//
//  BudgetView.swift
//  Expense Tracker
//
//  Created by John Menaker on 12/18/21.
//

import SwiftUI
import RealmSwift

struct BudgetView: View {
    @ObservedRealmObject var budget: Budget
    @State private var showingEdit = false

    var dateRange: ClosedRange<Date> {
        let min = budget.startDate
        var max = budget.endDate
        if min > max {
            max = min
        }
        return min...max
    }

    var body: some View {
        TextField("", text: $budget.name)
            .font(.title)
            .padding([.top, .trailing, .leading])
        Divider()
        VStack {
            SwiftUI.List {
                ForEach(budget.records, id: \.id) { record in
                    if budget.isAdvanced {
                        NavigationLink {
                            AdvancedRecordView(record: record, dateRange: dateRange, onDuplicate: {
                                $budget.records.append(Record(record))
                            })
                        } label: {
                            HStack {
                                Text("\(record.name)")
                                Spacer()
                                ColoredMoney(amount: record.amount ?? 0, isRed: record.isExpense)
                            }
                        }
                    } else {
                        RecordRow(record: record)
                    }
                }.onDelete(perform: $budget.records.remove)
                    .onMove(perform: $budget.records.move)
            }
        }.padding([.top, .bottom])
        .if(!budget.isAdvanced) { view in
            view.onTapGesture {
                self.hideKeyboard()
            }
        }
            .navigationBarTitle("", displayMode: .inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        showingEdit.toggle()
                    }) {
                        Text("Advanced")
                    }
                    EditButton()
                }
            }
            .sheet(isPresented: $showingEdit) {
                BudgetOptionsView(budget: budget)
            }
        Spacer()
        HStack {
            Button(action: {
                $budget.records.append(Record(isExpense: false))
            }) {
                Text("Add Income")
            }
            Spacer()
            Button(action: {
                $budget.records.append(Record(isExpense: true))
            }) {
                Text("Add Expense")
            }
        }.padding([.trailing, .leading])
        Divider()
        HStack {
            Text("Balance:")
            let balance = budget.calculateBalance()
            ColoredMoney(amount: abs(balance), isRed: balance < 0.0)
        }
        Divider()
    }

}

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

struct RecordRow: View {
    @ObservedRealmObject var record: Record

    var body: some View {
        HStack {
            TextField("title", text: $record.name)
            Divider()
            if let isExpense = record.isExpense {
                Text("\(isExpense ? "-" : "+")")
                    .foregroundColor(isExpense ? .red : .green )
                TextField("0", value: $record.amount, formatter: Formatter.decimal)
                    .foregroundColor(isExpense ? .red : .green )
                    .keyboardType(.decimalPad)
            }
        }
    }
}

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
                    TextField("", text: $record.name)

                }
                HStack {
                    Text("Amount")
                        .frame(width: 100, alignment: .leading)
                    TextField("0", value: $record.amount, formatter: Formatter.decimal)
                        .keyboardType(.decimalPad)
                }

                DatePicker("Date",
                           selection: $record.date,
                           in: dateRange,
                           displayedComponents: [.date]
                )

                HStack {
                    Text("Category")
                    Spacer()
                    if record.isExpense {
                        Picker("Category", selection: $record.category) {
                            ForEach(Array(MyCategories.keys.sorted(by: <)), id: \.self) { key in
                                HStack {
                                    if let category = MyCategories[key] {
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

        }.navigationTitle("")
    }
}
