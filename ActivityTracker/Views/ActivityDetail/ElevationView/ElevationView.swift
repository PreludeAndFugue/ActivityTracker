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
                .fill(Color.red)
                .frame(width: 1000, height: 150)
        }
        .padding(8)
        .background(Color("DisclosureBackground"))
        .cornerRadius(8)
        .padding(10)
    }
}


private struct ElevationPath: Shape {
    let points: [DistanceElevation]

    func path(in rect: CGRect) -> Path {
        var p = Path()
        p.move(to: .zero)
        for point in points {
            p.addLine(to: CGPoint(x: point.distance, y: point.elevation))
        }
        let x = p.currentPoint!.x
        p.addLine(to: CGPoint(x: x, y: 0))
        p.closeSubpath()
        let b = p.boundingRect
        let t = CGAffineTransform(scaleX: 900.0 / b.width, y: 120 / b.height)
            .scaledBy(x: 1, y: -1)
            .translatedBy(x: 0, y: -150)
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
