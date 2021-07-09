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
    let heights: [Double]
    let size: CGSize

    var body: some View {
        VStack {
            Chart(heights: heights, size: size)
                .foregroundColor(.purple)
                .border(Color.gray)
                .padding([.leading, .trailing], horizontalPadding)
                .border(Color.green)
            HStack(spacing: horizontalPadding / 2) {
                Text("M")
                    .frame(maxWidth: .infinity)
                    .border(Color.yellow)

                Text("T")
                    .frame(maxWidth: .infinity)
                    .border(Color.yellow)

                Text("W")
                    .frame(maxWidth: .infinity)
                    .border(Color.yellow)

                Text("T")
                    .frame(maxWidth: .infinity)
                    .border(Color.yellow)

                Text("F")
                    .frame(maxWidth: .infinity)
                    .border(Color.yellow)

                Text("S")
                    .frame(maxWidth: .infinity)
                    .border(Color.yellow)

                Text("S")
                    .frame(maxWidth: .infinity)
                    .border(Color.yellow)
            }
            .border(Color.blue)
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
            scaleX: (size.width - 2 * horizontalPadding) / b.width,
            y: (size.height - textVerticalSpace) / b.height
        )
        return path.applying(t)
    }
}


#if DEBUG
struct BarChartView_Previews: PreviewProvider {
    static var previews: some View {
        BarChartView(heights: [30, 60, 30, 0, 0, 114, 20.4], size: CGSize(width: 300, height: 100))
            .frame(width: 300, height: 100)
        BarChartView(heights: [30, 60, 30, 0, 0, 114, 20.4], size: CGSize(width: 100, height: 100))
            .frame(width: 100, height: 100)
    }
}
#endif
