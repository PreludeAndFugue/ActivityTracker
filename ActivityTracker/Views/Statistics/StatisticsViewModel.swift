//
//  StatisticsViewModel.swift
//  ActivityTracker
//
//  Created by gary on 09/07/2021.
//

import Combine
import Foundation

final class StatisticsViewModel: ObservableObject {
    private let calendar = Calendar.current
    let db: Database

    @Published var stats: Statistics


    init(db: Database) {
        self.db = db
        self.stats = db.stats(for: calendar.weekInterval(containing: Date()))
    }


    var bikeDistanceString: String {
        let m = Measurement(value: stats.bikeDistance, unit: UnitLength.meters)
        return distanceFormatter.string(from: m.converted(to: .kilometers))
    }


    var bikeElapsedTimeString: String {
        elapsedTimeFormatter.string(from: stats.bikeTime) ?? "00:00"
    }


    var bikeDayDistances: [Double] {
        stats.bikeDayDistances
    }
}
