//
//  DistanceProgressView.swift
//  ActivityTracker
//
//  Created by gary on 10/07/2021.
//

import SwiftUI

struct DistanceProgressView: View {
    let distance: Double
    let totalDistance: Double

    var body: some View {
        VStack(spacing: 10) {
            HStack(alignment: .firstTextBaseline) {
                Text(distanceString)
                    .font(.system(size: 25))
                Text("of " + totalDistanceString)
            }

            HStack {
                ProgressView(value: percentage, total: 1)
                    .accentColor(.accentColor)
                Text(percentageString)
            }
            .frame(width: 300)
        }
    }
}


// MARK: - Private

private extension DistanceProgressView {
    var distanceString: String {
        let m = Measurement(value: distance, unit: UnitLength.meters)
        return distanceFormatter.string(from: m.converted(to: .kilometers))
    }


    var totalDistanceString: String {
        let m = Measurement(value: totalDistance, unit: UnitLength.meters)
        return distanceFormatter.string(from: m.converted(to: .kilometers))
    }


    var percentage: Double {
        distance / totalDistance
    }


    var percentageString: String {
        let n = NSNumber(value: percentage)
        return percentageFormatter.string(from: n) ?? "0 %"
    }
}


#if DEBUG
struct DistanceProgressView_Previews: PreviewProvider {
    static var previews: some View {
        DistanceProgressView(distance: 130_000, totalDistance: 150_000)
    }
}
#endif
