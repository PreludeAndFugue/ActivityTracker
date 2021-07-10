//
//  WeekStatsView.swift
//  ActivityTracker
//
//  Created by gary on 10/07/2021.
//

import SwiftUI

struct WeekStatsView: View {
    let model: StatisticsViewModel

    
    var body: some View {
        VStack(spacing: 10) {
            DistanceProgressView(
                distance: model.bikeWeekDistance,
                totalDistance: model.bikeTotalWeekDistance
            )

            HStack {
                Text(model.bikeElapsedTimeString)

                Text(model.elevationGainString)
            }

            BarChartView(data: .week(model.bikeWeekDistances), size: CGSize(width: 300, height: 200))
        }
    }
}


#if DEBUG
struct WeekStatsView_Previews: PreviewProvider {
    private static let model = StatisticsViewModel(db: Database.dummy)
    static var previews: some View {
        WeekStatsView(model: model)
            .frame(width: 400)
    }
}
#endif
