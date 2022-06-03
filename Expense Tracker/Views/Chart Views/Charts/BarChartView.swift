//
//  BarChartView.swift
//  Expense Tracker
//
//  Created by John Menaker on 4/21/22.
//

import SwiftUI

func getAbsMax(_ values: [Double]) -> Double {
    let a = values.max() ?? 1
    let b = abs(values.min() ?? 1)
    return max(a, b)
}

struct VBarChartView: View {
    var names: [String] = []
    var values: [Double] = []
    let formatter: NumberFormatter

    init(data: [(String, Double)], formatter: NumberFormatter) {
        for i in 0..<data.count {
            names.append(data[i].0)
            values.append(data[i].1)
        }

        self.formatter = formatter
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width * 0.55
            let height = geometry.size.height * 0.66
            let maxValue = getAbsMax(values)

            ZStack {
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color(.systemGray6))
                VStack {
                    ForEach(0..<self.values.count, id: \.self) { i in
                        let name = self.names[i]
                        let value = self.values[i]
                        HStack {
                            Text(name)
                                .frame(width: geometry.size.width * 0.10)
                            if value == 0.0 {
                                Bar(width: 1, height: height / CGFloat(values.count), color: .red)
                            } else {
                                Bar(width: width / maxValue * abs(value), height: height / CGFloat(values.count), color: value >= 0 ? .red : .green)
                            }

                            Spacer()
                            Text(formatter.string(from: NSNumber(value: value)) ?? "")
                                .padding()
                        }
                    }
                }
                .padding()
            }
            .padding()
        }
    }
}

struct HBarChartView: View {
    var names: [String] = []
    var values: [Double] = []
    let formatter: NumberFormatter
    let title: String?

    init(data: [(String, Double)], formatter: NumberFormatter, title: String?) {
        for i in 0..<data.count {
            names.append(data[i].0)
            values.append(data[i].1)
        }

        self.formatter = formatter
        self.title = title
    }

    var body: some View {
        GeometryReader { geometry in
            let width = geometry.size.width * 0.66
            let height = geometry.size.height * 0.66
            let maxValue = getAbsMax(values)
            ZStack {
                RoundedRectangle(cornerRadius: 5.0)
                    .fill(Color(.systemGray6))
                VStack {
                    Text(title ?? "")
                        .padding()
                    Spacer()
                    HStack {
                        ForEach(0..<self.values.count, id: \.self) { i in
                            let name = self.names[i]
                            let value = self.values[i]
                            let barWidth = width / CGFloat(values.count)

                            VStack {
                                Spacer()
                                Text(formatter.string(from: NSNumber(value: value)) ?? "")
                                    .font(.footnote)
                                Bar(width: barWidth, height: (height / maxValue * abs(self.values[i])), color: value >= 0 ? .red : .green)
                                Text(name)
                                    .font(.footnote)
                                    .frame(width: CGFloat(barWidth))
                                    .lineLimit(1)
                                    .truncationMode(.tail)
                            }
                            .padding([.bottom])
                        }
                    }
                }
            }
            .padding()
        }
    }
}

struct Bar: View {
    let width: Double
    let height: Double
    let color: Color

    var body: some View {
        RoundedRectangle(cornerRadius: 3.0)
            .fill(color.opacity(0.3))
            .frame(width: CGFloat(width), height: CGFloat(height), alignment: .trailing)
    }
}

struct VLine: Shape {
    let x: CGFloat
    func path(in rect: CGRect) -> Path {
        Path { path in
            path.move(to: CGPoint(x: x, y: rect.minY))
            path.addLine(to: CGPoint(x: x, y: rect.maxY))
        }
    }
}
