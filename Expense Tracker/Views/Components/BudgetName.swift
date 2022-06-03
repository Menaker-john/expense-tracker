//
//  BudgetName.swift
//  Expense Tracker
//
//  Created by John Menaker on 4/11/22.
//

import SwiftUI

struct BudgetName: View {
    var name: String
    var isArchived: Bool

    var body: some View {
        Text(
            ( name == "" ? "New Budget" : name ) +
            ( isArchived ? "(Archived)" : "" )
        )
    }
}
