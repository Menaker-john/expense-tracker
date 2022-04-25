//
//  BarChartView.swift
//  Expense Tracker
//
//  Created by John Menaker on 4/21/22.
//

import SwiftUI

struct BarChartView: View {
    let names: [String]
    let values: [Double]
    let formatter: NumberFormatter
    let isHorizontal: Bool

    func getAbsMax() -> Double {
        let max = values.max() ?? 1
        let min = abs(values.min() ?? 1)
        return max >= min ? max : min
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width * 0.66
            let height = geometry.size.height * 0.66
            let maxValue = getAbsMax()

            ZStack {
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color(.systemGray6))
                ConditionalStack(isHorizontal) {
                    ForEach(0..<self.values.count, id: \.self) { i in
                        if isHorizontal {
                            VBarView(name: self.names[i], value: self.values[i], width: width / CGFloat(values.count), height: (height / maxValue * abs(self.values[i])), formatter: formatter)
                        } else {
                            HBarView(name: self.names[i], value: self.values[i], width: (width / maxValue * abs(self.values[i])), height: height / CGFloat(values.count), formatter: formatter)
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct HBarView: View {
    let name: String
    let value: Double
    let width: Double
    let height: Double
    let formatter: NumberFormatter

    var body: some View {
        HStack {
            Text(name)
            Bar(width: width, height: height)
            Text(formatter.string(from: NSNumber(value: value)) ?? "")
                .font(.footnote)
            Spacer()
        }.padding(.horizontal, 5)
    }
}

struct VBarView: View {
    let name: String
    let value: Double
    let width: Double
    let height: Double
    let formatter: NumberFormatter

    var body: some View {
        VStack {
            Spacer()
            Text(formatter.string(from: NSNumber(value: value)) ?? "")
                .font(.footnote)
            Bar(width: width, height: height)
            Text(name)
                .frame(width: CGFloat(width))
                .lineLimit(1)
                .truncationMode(.tail)

        }.padding(.horizontal, 5)
    }
}

struct Bar: View {
    let width: Double
    let height: Double

    var body: some View {
        RoundedRectangle(cornerRadius: 3.0)
            .fill(.blue)
            .frame(width: CGFloat(width), height: CGFloat(height), alignment: .trailing)
    }
}
