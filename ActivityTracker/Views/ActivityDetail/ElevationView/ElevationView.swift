//
//  ElevationView.swift
//  ActivityTracker
//
//  Created by gary on 03/07/2021.
//

import SwiftUI

struct ElevationView: View {
    @EnvironmentObject var coordinator: AppCoordinator

    var body: some View {
        DisclosureGroup("Elevation profile") {
            ElevationPath(points: coordinator.activityElevationData)
                .fill(linearGradient)
                .frame(width: 1000, height: 150)
        }
        .padding(8)
        .background(Color("DisclosureBackground"))
        .cornerRadius(8)
        .padding(10)
    }
}


// MARK: - Private

private extension ElevationView {
    var linearGradient: LinearGradient {
        let translucentRed = Color(.sRGB, red: 1, green: 0, blue: 0, opacity: 0.4)
        let gradient = Gradient(colors: [.red, translucentRed])
        return LinearGradient(
            gradient: gradient,
            startPoint: .zero,
            endPoint: UnitPoint(x: 0, y: 1)
        )
    }
}


private struct ElevationPath: Shape {
    let points: [DistanceElevation]

    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: CGPoint(x: 0, y: 120))
        for point in points {
            p.addLine(to: CGPoint(x: point.distance, y: 120 - point.elevation))
        }
        let x = p.currentPoint!.x
        p.addLine(to: CGPoint(x: x, y: 120))
        p.closeSubpath()
        let b = p.boundingRect

        let t = CGAffineTransform(scaleX: 950.0 / b.width, y: 120 / b.height)
            .translatedBy(x: 0, y: 30)

        return p.applying(t)
    }
}


#if DEBUG
struct ElevationView_Previews: PreviewProvider {
    static var previews: some View {
        ElevationView()
    }
}
#endif
