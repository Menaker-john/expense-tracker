//
//  Categories.swift
//  Expense Tracker
//
//  Created by John Menaker on 1/28/22.
//

import SwiftUI

struct Category {
    var image: String = ""
    var color: Color = Color.black
}

func rgb(_ r: Double, _ g: Double, _ b: Double) -> Color {
    return Color(red: r/255, green: g/255, blue: b/255, opacity: 1.0)
}

let Categories: [String: Category] = [
    "Expense": Category(image: "e.circle", color: rgb(12, 228, 153)),
    "Groceries": Category(image: "cart", color: Color.blue),
    "Transportation": Category(image: "car", color: Color.gray),
    "Cosmetics": Category(image: "hands.sparkles", color: Color.green),
    "Clothing": Category(image: "tshirt", color: Color.red),
    "Food": Category(image: "takeoutbag.and.cup.and.straw", color: Color.pink),
    "Healthcare": Category(image: "stethoscope", color: rgb(62, 180, 137)),
    "Housing": Category(image: "house", color: rgb(48, 213, 200)),
    "Utilities": Category(image: "lightbulb", color: Color.orange),
    "Entertainment": Category(image: "film", color: Color.purple),
    "Miscellaneous": Category(image: "folder", color: Color.yellow),
    "Savings": Category(image: "cloud.rain", color: rgb(128, 164, 237))
]
