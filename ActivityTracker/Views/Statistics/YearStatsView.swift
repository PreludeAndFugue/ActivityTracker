//
//  YearStatsView.swift
//  ActivityTracker
//
//  Created by gary on 10/07/2021.
//

import SwiftUI

struct YearStatsView: View {
    @StateObject var model: StatisticsViewModel

    var body: some View {
        VStack(spacing: 10) {
            Text(year)
                .font(.system(size: 20))
            
            DistanceProgressView(
                distance: model.bikeYearDistance,
                totalDistance: model.bikeTotalYearDistance
            )

            HStack(spacing: 15) {
                Text(model.bikeYearElapsedTimeString)
                Divider()
                    .frame(height: 25)
                Text(model.bikeYearElevationGainString)
            }
        }
    }
}


// MARK: - Private

private extension YearStatsView {
    var year: String {
        let year = Calendar.current.dateComponents([.year], from: model.date).year ?? 2000
        return "\(year)"
    }
}


#if DEBUG
struct YearStatsView_Previews: PreviewProvider {
    static let db = Database.dummy
    static let model = StatisticsViewModel(db: db)
    static var previews: some View {
        YearStatsView(model: model)
    }
}
#endif
