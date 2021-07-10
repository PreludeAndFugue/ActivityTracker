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
        let d = distance / totalDistance
        if d > 1 {
            return 1
        } else {
            return d
        }
    }


    var percentageString: String {
        let d = distance / totalDistance
        let n = NSNumber(value: d)
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
