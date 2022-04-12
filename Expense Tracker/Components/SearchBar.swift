//
//  SearchBar.swift
//  Expense Tracker
//
//  Created by John Menaker on 4/10/22.
//

import SwiftUI

struct SearchBar: View {
    @Binding var text: String
    @Binding var isSearching: Bool
    @Binding var isEditing: Bool

    var body: some View {
        HStack {
            TextField("Search...", text: $text)
                .padding(7)
                .padding(.horizontal, 25)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .overlay(
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                            .frame(minWidth: 0, maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 8)

                        if isSearching {
                            Button(action: {
                                self.text = ""
                            }) {
                                Image(systemName: "multiply.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(.trailing, 8)
                            }
                        }
                    }
                )
                .padding(.horizontal, 10)
                .onTapGesture {
                    self.isSearching = true
                    // For preventing List Editing while using SearchBar
                    self.isEditing = false
                }

            if isSearching {
                Button(action: {
                    self.isSearching = false
                    self.text = ""

                    UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
                }) {
                    Text("Cancel")
                }
                .padding(.trailing, 10)
                .transition(.move(edge: .trailing))
            }
        }
    }
}
