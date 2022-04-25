//
//  ColoredMoney.swift
//  Expense Tracker
//
//  Created by John Menaker on 1/21/22.
//

import SwiftUI

struct ColoredMoney: View {
    var amount: Double = 0.0
    var isRed: Bool = false
    var body: some View {
        Text("\(isRed ? "-": "")\(Formatter.money.string(from: NSNumber(value: amount)) ?? "")")
            .foregroundColor(isRed ? .red : .green )
    }
}
