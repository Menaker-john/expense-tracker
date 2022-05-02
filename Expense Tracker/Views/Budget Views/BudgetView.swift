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

    private var dateRange: ClosedRange<Date> {
        let min = budget.startDate
        var max = budget.endDate
        if min > max {
            max = min
        }
        return min...max
    }

    var body: some View {
        VStack {
            HStack() {
                TextField("New Budget", text: $budget.name)
                    .font(.title2)
                    .padding(7)
                    .padding(.horizontal, 25)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .disabled(budget.isArchived)
                Spacer()
                let balance = budget.calculateBalance()
                ColoredMoney(amount: abs(balance), isRed: balance < 0.0)
            }
            .padding()

            SwiftUI.List {
                ForEach(budget.records, id: \.id) { record in
                    if budget.isAdvanced {
                        NavigationLink {
                            AdvancedRecordView(record: record, dateRange: dateRange, onDuplicate: {
                                $budget.records.append(Record(record))
                            })
                        } label: {
                            HStack {
                                Text("\(record.name != "" ? record.name : "New Record")")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                Text(Formatter.date.string(from: record.date))
                                    .frame(maxWidth: .infinity, alignment: .center)
                                ColoredMoney(amount: record.amount, isRed: record.isExpense)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                        }
                    } else {
                        RecordRow(record: record)
                    }
                }
                .onDelete(perform: $budget.records.remove)
                .onMove(perform: $budget.records.move)
                .disabled(budget.isArchived)
            }
            HStack {
                Button(action: {
                    $budget.records.append(Record(isExpense: false, date: budget.startDate))
                }) {
                    Text("Add Income")
                    ColoredMoney(amount: budget.calculateIncome(), isRed: false)
                }
                Spacer()
                Button(action: {
                    $budget.records.append(Record(isExpense: true, date: budget.startDate))
                }) {
                    Text("Add Expense")
                    ColoredMoney(amount: budget.calculateExpense(), isRed: true)
                }

            }
            .padding()
            .disabled(budget.isArchived)
            Divider()
        }
        .padding([.top, .bottom])
        .if(!budget.isAdvanced) { view in
            view.onTapGesture {
                self.hideKeyboard()
            }
        }
        .navigationBarTitle("", displayMode: .inline)
        .toolbar {
            ToolbarItemGroup(placement: .navigationBarTrailing) {
                Button(action: {
                    showingEdit = true
                }) {
                    Text("Settings")
                }
                EditButton().disabled(budget.isArchived)
            }
        }
        .sheet(isPresented: $showingEdit) {
            BudgetOptionsView(budget: budget)
        }
    }
}
