//
//  WeekStatsView.swift
//  ActivityTracker
//
//  Created by gary on 10/07/2021.
//

import SwiftUI

struct WeekStatsView: View {
    @StateObject var model: StatisticsViewModel

    
    var body: some View {
        VStack(spacing: 10) {
            DistanceProgressView(
                distance: model.bikeWeekDistance,
                totalDistance: model.bikeTotalWeekDistance
            )

            HStack(spacing: 15) {
                Text(model.bikeWeekElapsedTimeString)
                Divider()
                    .frame(height: 25)
                Text(model.bikeWeekElevationGainString)
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
