//
//  BarChartView.swift
//  ActivityTracker
//
//  Created by gary on 09/07/2021.
//

import SwiftUI

struct BarChartView: View {
    let heights: [Double]
    let size: CGSize

    var body: some View {
        VStack {
            Chart(heights: heights, size: size)
                .foregroundColor(.purple)
                .border(Color.green)
            HStack(spacing: 5) {
                Text("M")
                    .frame(maxWidth: .infinity)
                Text("T")
                    .frame(maxWidth: .infinity)
                Text("W")
                    .frame(maxWidth: .infinity)
                Text("T")
                    .frame(maxWidth: .infinity)
                Text("F")
                    .frame(maxWidth: .infinity)
                Text("S")
                    .frame(maxWidth: .infinity)
                Text("S")
                    .frame(maxWidth: .infinity)
            }
            .border(Color.pink)
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
        let t = CGAffineTransform(scaleX: size.width / b.width, y: (size.height - 30) / b.height)
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
