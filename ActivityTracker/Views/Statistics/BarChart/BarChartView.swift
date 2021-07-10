//
//  BarChartView.swift
//  ActivityTracker
//
//  Created by gary on 09/07/2021.
//

import SwiftUI

private let horizontalPadding: CGFloat = 10
private let textVerticalSpace: CGFloat = 20

struct BarChartView: View {
    enum DataPoints {
        case week([Double])
        case month([Double])
    }


    let data: DataPoints
    let size: CGSize

    var body: some View {
        VStack {
            Chart(heights: data.values, size: size)
                .foregroundColor(.accentColor)
                .border(Color.gray)
                .border(Color.green)
            HStack(spacing: 0) {
                ForEach(data.labels, id: \.hashValue) { label in
                    Text(label)
                        .frame(maxWidth: .infinity)
                        .border(Color.yellow)
                }
            }
            .border(Color.blue)
        }
        .frame(width: size.width, height: size.height)
    }
}


private extension BarChartView.DataPoints {
    var values: [Double] {
        switch self {
        case .month(let values):
            return values
        case .week(let values):
            return values
        }
    }

    var labels: [String] {
        switch self {
        case .month(let values):
            return values.enumerated().map({ "\($0.offset + 1)" })
        case .week:
            return ["M", "T", "W", "T", "F", "S", "S"]
        }
    }
}


private struct Chart: Shape {
    let heights: [Double]
    let size: CGSize

    func path(in rect: CGRect) -> Path {
        let max = heights.max() ?? 0
        let path = Path() { p in
            p.move(to: .zero)
            for (dx, h) in heights.enumerated() {
                p.addRect(CGRect(x: 15.0 * Double(dx), y: max - h, width: 10, height: h))

            }
        }
        let b = path.boundingRect
        let t = CGAffineTransform(
            scaleX: (size.width) / b.width,
            y: (size.height - textVerticalSpace) / b.height
        )
        return path.applying(t)
    }
}


#if DEBUG
struct BarChartView_Previews: PreviewProvider {
    private static let data: BarChartView.DataPoints = .week([30, 60, 30, 0, 0, 114, 20.4])
    static var previews: some View {
        BarChartView(data: data, size: CGSize(width: 300, height: 100))
            .frame(width: 300, height: 100)
        BarChartView(data: data, size: CGSize(width: 100, height: 100))
            .frame(width: 100, height: 100)
        BarChartView(data: data, size: CGSize(width: 500, height: 200))
            .frame(width: 500, height: 200)
    }
}
#endif
