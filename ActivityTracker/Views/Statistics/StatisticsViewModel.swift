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
        self.stats = db.stats(for: Date())
    }


    var bikeWeekDistance: Double {
        stats.bikeDistance(for: .week)
    }


    var bikeTotalWeekDistance: Double {
        stats.weeklyGoal
    }


    var bikeYearDistance: Double {
        stats.bikeDistance(for: .year)
    }


    var bikeTotalYearDistance: Double {
        stats.annualGoal
    }


    var bikeDistanceString: String {
        let m = Measurement(value: stats.bikeDistance(for: .week), unit: UnitLength.meters)
        return distanceFormatter.string(from: m.converted(to: .kilometers))
    }

    
    var bikeWeekString: String {
        let m = Measurement(value: stats.weeklyGoal, unit: UnitLength.meters)
        return distanceFormatter.string(from: m.converted(to: .kilometers))
    }


    var bikeElapsedTimeString: String {
        elapsedTimeFormatter.string(from: stats.bikeTime(for: .week)) ?? "00:00"
    }


    var bikeWeekPercentage: CGFloat {
        CGFloat(stats.bikeDistance(for: .week) / stats.weeklyGoal)
    }


    var bikeWeekPercentageString: String {
        let d = Double(bikeWeekPercentage)
        return percentageFormatter.string(from: NSNumber(value: d)) ?? "0 %"
    }


    var elevationGainString: String {
        return "600m"
    }


    var bikeWeekDistances: [Double] {
        stats.bikeDayDistances(for: .week)
    }


    var bikeMonthDistances: [Double] {
        stats.bikeDayDistances(for: .month)
    }
}
