//
//  PieChartView.swift
//
//
//  Created by Nazar Ilamanov on 4/23/21.
//

import SwiftUI

@available(OSX 10.15, *)
public struct PieChartView: View {
    public let values: [Double]
    public let names: [String]
    public let formatter: NumberFormatter

    public var widthFraction: CGFloat
    public var innerRadiusFraction: CGFloat

    @State private var activeIndex: Int = -1

    var slices: [PieSliceData] {
        let sum = values.reduce(0, +)
        var endDeg: Double = 0
        var tempSlices: [PieSliceData] = []

        for (i, value) in values.enumerated() {
            let degrees: Double = value * 360 / sum
            tempSlices.append(PieSliceData(startAngle: Angle(degrees: endDeg), endAngle: Angle(degrees: endDeg + degrees), text: String(format: "%.0f%%", value * 100 / sum), color: MyCategories[self.names[i]]?.color ?? .black))
            endDeg += degrees
        }
        return tempSlices
    }

    public init(values: [Double], names: [String], formatter: NumberFormatter, widthFraction: CGFloat = 0.75, innerRadiusFraction: CGFloat = 0.60) {
        let combined = zip(names, values).sorted {
            $0.1 > $1.1
        }
        let sortedNames = combined.map {$0.0}
        let sortedValues = combined.map {$0.1}

        self.values = sortedValues
        self.names = sortedNames
        self.formatter = formatter
        self.widthFraction = widthFraction
        self.innerRadiusFraction = innerRadiusFraction

    }

    public var body: some View {
        GeometryReader { geometry in
            VStack {
                ZStack {
                    ForEach(0..<self.values.count, id: \.self) { i in
                        PieSlice(pieSliceData: self.slices[i])
                    }
                    .frame(width: widthFraction * geometry.size.width, height: widthFraction * geometry.size.width)
                }
                PieChartRows(names: self.names, values: self.values.map { self.formatter.string(from: NSNumber(value: $0)) ?? ""}, percents: self.values.map { String(format: "%.0f%%", $0 * 100 / self.values.reduce(0, +)) })
                    .padding()
            }
        }
    }
}

@available(OSX 10.15, *)
struct PieChartRows: View {
    var names: [String]
    var values: [String]
    var percents: [String]

    var body: some View {
        ScrollView {
            ForEach(0..<self.values.count, id: \.self) { i in
                HStack {
                    RoundedRectangle(cornerRadius: 5.0)
                        .fill(MyCategories[self.names[i]]?.color ?? .black)
                        .frame(width: 20, height: 20)
                    Text(self.names[i])
                    Spacer()
                    VStack(alignment: .trailing) {
                        Text(self.values[i])
                        Text(self.percents[i])
                    }
                }
            }.padding()
        }
    }
}

@available(OSX 10.15, *)
struct PieSlice: View {
    var pieSliceData: PieSliceData

    var midRadians: Double {
        return Double.pi / 2.0 - (pieSliceData.startAngle + pieSliceData.endAngle).radians / 2.0
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Path { path in
                    let width: CGFloat = min(geometry.size.width, geometry.size.height)
                    let height = width
                    path.move(
                        to: CGPoint(
                            x: width * 0.5,
                            y: height * 0.5
                        )
                    )

                    path.addArc(center: CGPoint(x: width * 0.5, y: height * 0.5), radius: width * 0.5, startAngle: Angle(degrees: -90.0) + pieSliceData.startAngle, endAngle: Angle(degrees: -90.0) + pieSliceData.endAngle, clockwise: false)

                }
                .fill(pieSliceData.color)

                Text(pieSliceData.text)
                    .position(
                        x: geometry.size.width * 0.5 * CGFloat(1.0 + 0.78 * cos(self.midRadians)),
                        y: geometry.size.height * 0.5 * CGFloat(1.0 - 0.78 * sin(self.midRadians))
                    )
            }
        }
        .aspectRatio(1, contentMode: .fit)
    }
}

@available(OSX 10.15, *)
struct PieSliceData {
    var startAngle: Angle
    var endAngle: Angle
    var text: String
    var color: Color
}
