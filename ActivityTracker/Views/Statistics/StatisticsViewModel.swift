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
    private let db: Database

    var date = Date()

    @Published var stats: Statistics


    init(db: Database) {
        self.db = db
        self.stats = db.stats(for: date)
    }


    var weekInterval: DateInterval {
        stats.weekInterval
    }


    var bikeWeekDistance: Double {
        stats.bikeDistance(for: .week)
    }


    var bikeTotalWeekDistance: Double {
        stats.weeklyGoal
    }


    // MARK: - Week


    var bikeWeekDistanceString: String {
        let m = Measurement(value: bikeWeekDistance, unit: UnitLength.meters)
        return distanceFormatter.string(from: m.converted(to: .kilometers))
    }

    
    var bikeWeekString: String {
        let m = Measurement(value: stats.weeklyGoal, unit: UnitLength.meters)
        return distanceFormatter.string(from: m.converted(to: .kilometers))
    }


    var bikeWeekElapsedTimeString: String {
        elapsedTimeFormatter.string(from: stats.bikeTime(for: .week)) ?? "00:00"
    }


    var bikeWeekPercentage: CGFloat {
        CGFloat(stats.bikeDistance(for: .week) / stats.weeklyGoal)
    }


    var bikeWeekPercentageString: String {
        let d = Double(bikeWeekPercentage)
        return percentageFormatter.string(from: NSNumber(value: d)) ?? "0 %"
    }


    var bikeWeekElevationGainString: String {
        return "600m"
    }


    // MARK: - Month

    var bikeMonthDistance: Double {
        stats.bikeDistance(for: .month)
    }


    var bikeMonthDistanceString: String {
        let m = Measurement(value: bikeMonthDistance, unit: UnitLength.meters)
        return distanceFormatter.string(from: m.converted(to: .kilometers))
    }


    var bikeMonthElapsedTimeString: String {
        elapsedTimeFormatter.string(from: stats.bikeTime(for: .month)) ?? "00:00"
    }


    var bikeWeekDistances: [Double] {
        stats.bikeDayDistances(for: .week)
    }


    var bikeMonthDistances: [Double] {
        stats.bikeDayDistances(for: .month)
    }


    var bikeMonthElevationGainString: String {
        return "600m"
    }


    // MARK: - Year

    var bikeYearDistance: Double {
        stats.bikeDistance(for: .year)
    }


    var bikeTotalYearDistance: Double {
        stats.annualGoal
    }


    var bikeYearElapsedTimeString: String {
        elapsedTimeFormatter.string(from: stats.bikeTime(for: .year)) ?? "00:00"
    }


    var bikeYearElevationGainString: String {
        return "600m"
    }


    // MARK: - Navigation

    func previousWeek() {
        date = calendar.date(byAdding: .day, value: -7, to: date)!
        stats = db.stats(for: date)
    }


    func nextWeek() {
        date = calendar.date(byAdding: .day, value: 7, to: date)!
        stats = db.stats(for: date)
    }
}
