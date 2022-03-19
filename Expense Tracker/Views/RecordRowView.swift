//
//  RecordRowView.swift
//  Expense Tracker
//
//  Created by John Menaker on 3/18/22.
//

import SwiftUI
import RealmSwift

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
