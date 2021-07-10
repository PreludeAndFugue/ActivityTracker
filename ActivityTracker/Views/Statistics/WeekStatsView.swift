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
            HStack(alignment: .firstTextBaseline) {
                Text(model.bikeDistanceString)
                    .font(.system(size: 25))
                Text("of " + model.bikeWeekString)
            }

            HStack {
                ZStack(alignment: .leading) {
                    Capsule(style: .circular)
                        .foregroundColor(.gray)
                        .opacity(0.5)
                        .frame(width: 200, height: 10)
                    Capsule(style: .continuous)
                        .foregroundColor(.purple)
                        .frame(width: 200 * model.bikeWeekPercentage, height: 10)
                }
                Text(model.bikeWeekPercentageString)
            }
            .frame(width: 300)

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
    private static let model = StatisticsViewModel(db: try! Database(inMemory: true))
    static var previews: some View {
        WeekStatsView(model: model)
    }
}
#endif
