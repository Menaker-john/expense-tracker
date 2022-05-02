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
    "Groceries": Category(image: "cart", color: Color.blue.opacity(0.3)),
    "Transportation": Category(image: "car", color: Color.gray.opacity(0.3)),
    "Cosmetics": Category(image: "hands.sparkles", color: Color.green.opacity(0.3)),
    "Clothing": Category(image: "tshirt", color: Color.red.opacity(0.3)),
    "Take Out": Category(image: "takeoutbag.and.cup.and.straw", color: Color.pink.opacity(0.3)),
    "Utilities": Category(image: "lightbulb", color: Color.orange.opacity(0.3)),
    "Entertainment": Category(image: "film", color: Color.purple.opacity(0.3)),
    "Miscellaneous": Category(image: "folder", color: Color.yellow.opacity(0.3)),
    "Savings": Category(image: "cloud.rain", color: Color.cyan.opacity(0.3)),
    "Expense": Category(image: "e.circle", color: Color.indigo.opacity(0.3)),
    "Healthcare": Category(image: "stethoscope", color: Color.mint.opacity(0.3)),
    "Housing": Category(image: "house", color: Color.teal)
]
