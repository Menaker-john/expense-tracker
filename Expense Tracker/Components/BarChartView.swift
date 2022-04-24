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

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width * 0.66
            let height = geometry.size.height * 0.66 / CGFloat(values.count)
            let maxValue = values.max() ?? 1

            ZStack {
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color(.systemGray6))
                VStack {
                    ForEach(0..<self.values.count, id: \.self) { i in
                        BarView(name: self.names[i], value: self.values[i], width: (width / maxValue * self.values[i]), maxWidth: geometry.size.width * 0.75, height: height, formatter: formatter)
                    }
                }
            }
            .padding()
        }
    }
}

struct BarView: View {
    let name: String
    let value: Double
    let width: Double
    let maxWidth: Double
    let height: Double
    let formatter: NumberFormatter

    var body: some View {
        HStack {
            Text(name)
            ZStack(alignment: .leading) {
                VStack {
                    RoundedRectangle(cornerRadius: 3.0)
                        .fill(Color.blue)
                        .frame(width: CGFloat(width), height: CGFloat(height), alignment: .trailing)
                }
            }
            if value > 0 {
                Text(formatter.string(from: NSNumber(value: value)) ?? "")
                    .font(.footnote)
            }
            Spacer()
        }.padding(.horizontal, 5)
    }
}

// https://stackoverflow.com/questions/58526632/swiftui-create-a-single-dashed-line-with-swiftui
// struct VLine: Shape {
//
//    let x: CGFloat
//
//    func path(in rect: CGRect) -> Path {
//        Path { path in
//            path.move(to: CGPoint(x: x, y: rect.minY))
//            path.addLine(to: CGPoint(x: x, y: rect.maxY))
//        }
//    }
// }
