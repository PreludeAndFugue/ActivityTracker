//
//  Statistics.swift
//  ActivityTracker
//
//  Created by gary on 09/07/2021.
//

import Foundation

struct Statistics {
    private let calendar = Calendar.current
    private let dateInterval: DateInterval
    private let activities: [Activity]


    init(dateInterval: DateInterval, activities: [Activity]) {
        self.dateInterval = dateInterval
        self.activities = activities
    }


    var bikeDistance: Double {
        activities.filter({ $0.type == .bike })
            .map({ $0.distance })
            .reduce(0, +)
    }


    var bikeTime: TimeInterval {
        activities.filter({ $0.type == .bike })
            .map({ $0.elapsedTime })
            .reduce(0, +)
    }


    var bikeDayDistances: [Double] {
        var dict: [Date: Double] = [:]
        for activity in activities {
            let date = calendar.startOfDay(for: activity.date)
            dict[date] = dict[date, default: 0] + activity.distance
        }
        var distances: [Double] = []
        for date in calendar.dates(in: dateInterval) {
            distances.append(dict[date, default: 2])
        }
        return distances
    }
}
