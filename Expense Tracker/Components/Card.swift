//
//  CardButton.swift
//  Expense Tracker
//
//  Created by John Menaker on 4/18/22.
//

import SwiftUI

struct Card: View {
    @State var title: String

    var body: some View {
        Text(title)
            .frame(maxWidth: .infinity)
            .foregroundColor(.black)
            .padding(.vertical, 40)
            .background(Color(.systemGray6))
            .cornerRadius(10)
    }
}
