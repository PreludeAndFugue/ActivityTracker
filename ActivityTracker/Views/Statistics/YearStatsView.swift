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
            DistanceProgressView(
                distance: model.bikeYearDistance,
                totalDistance: model.bikeTotalYearDistance
            )
        }
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
