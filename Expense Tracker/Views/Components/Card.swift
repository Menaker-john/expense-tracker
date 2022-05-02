//
//  CardButton.swift
//  Expense Tracker
//
//  Created by John Menaker on 4/18/22.
//

import SwiftUI

struct Card: View {
    @State var title: String
    var color: Color
    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 40)
            .background(color)
            .cornerRadius(20)
    }
}
