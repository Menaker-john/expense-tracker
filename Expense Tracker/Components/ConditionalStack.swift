//
//  ConditionalStack.swift
//  Expense Tracker
//
//  Created by John Menaker on 4/25/22.
//

import SwiftUI

struct ConditionalStack<Content: View>: View {
    let isHorizontal: Bool
    let content: () -> Content

    init(_ isHorizontal: Bool = true, @ViewBuilder content: @escaping () -> Content) {
        self.isHorizontal = isHorizontal
        self.content = content
    }

    var body: some View {
        if isHorizontal {
            HStack(content: content)
        } else {
            VStack(content: content)
        }
    }
}
