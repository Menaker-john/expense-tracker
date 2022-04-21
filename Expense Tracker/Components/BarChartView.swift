//
//  BarChartView.swift
//  Expense Tracker
//
//  Created by John Menaker on 4/21/22.
//

import SwiftUI

struct BarChartView: View {
    var names: [String]
    var values: [Double]

    var body: some View {
        GeometryReader { geometry in
            let chartHeight = geometry.size.width * 0.66
            let maxValue = values.max() ?? 1
            ZStack {
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color(.systemGray6))
                VStack {
                    ForEach(0..<self.values.count, id: \.self) { i in
                        BarView(name: self.names[i], value: self.values[i], maxValue: maxValue, maxHeight: chartHeight)
                    }
                }
            }
        }
    }
}

struct BarView: View {
    var name: String
    var value: Double
    var maxValue: Double
    var maxHeight: Double

    var barHeight: Double {
        maxHeight / maxValue * value
    }

    var body: some View {
        HStack {
            Text(name)
            ZStack {
                VStack {
                    Spacer()
                    RoundedRectangle(cornerRadius: 3.0)
                        .fill(Color.blue)
                        .frame(width: CGFloat(barHeight), alignment: .trailing)
                }
                VStack {
                    Spacer()
                    if value > 0 {
                        Text("\(value, specifier: "%.0F")")
                            .font(.footnote)
                            .foregroundColor(.white)
                            .fontWeight(.bold)
                    }
                }
            }
            Spacer()
        }
    }
}
