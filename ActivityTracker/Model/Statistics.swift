//
//  Statistics.swift
//  ActivityTracker
//
//  Created by gary on 09/07/2021.
//

import Foundation

struct Statistics {
    enum Interval {
        case week
        case month
        case year
    }

    struct IntervalActivities {
        let dateInterval: DateInterval
        let activities: [Activity]
    }


    private let calendar = Calendar.current
    private let week: IntervalActivities
    private let month: IntervalActivities
    private let year: IntervalActivities

    let weeklyGoal = 150_000.0
    let annualGoal = 7_500_000.0


    init(week: IntervalActivities, month: IntervalActivities, year: IntervalActivities) {
        self.week = week
        self.month = month
        self.year = year
    }


    var weekInterval: DateInterval {
        week.dateInterval
    }


    func bikeDistance(for interval: Interval) -> Double {
        bikeActivities(for: interval)
            .map({ $0.distance })
            .reduce(0, +)
    }


    func bikeTime(for interval: Interval) -> TimeInterval {
        bikeActivities(for: interval)
            .map({ $0.elapsedTime })
            .reduce(0, +)
    }


    func bikeDayDistances(for interval: Interval) -> [Double] {
        var dict: [Date: Double] = [:]
        for activity in bikeActivities(for: interval) {
            let date = calendar.startOfDay(for: activity.date)
            dict[date] = dict[date, default: 0] + activity.distance
        }
        var distances: [Double] = []
        for date in calendar.dates(in: dateInterval(for: interval)) {
            distances.append(dict[date, default: 2])
        }
        return distances
    }


    func bikeElevationGain(for interval: Interval) -> Double {
        return 0
    }
}


// MARK: - Private

private extension Statistics {
    func bikeActivities(for interval: Interval) -> [Activity] {
        switch interval {
        case .week:
            return week.activities.filter({ $0.type == .bike })
        case .month:
            return month.activities.filter({ $0.type == .bike})
        case .year:
            return year.activities.filter({ $0.type == .bike })
        }
    }


    func dateInterval(for interval: Interval) -> DateInterval {
        switch interval {
        case .week:
            return week.dateInterval
        case .month:
            return month.dateInterval
        case .year:
            return year.dateInterval
        }
    }
}
