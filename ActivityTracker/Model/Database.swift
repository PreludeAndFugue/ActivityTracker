//
//  Database.swift
//  ActivityTracker
//
//  Created by gary on 25/06/2021.
//

import Combine

final class Database: ObservableObject {
    @Published var currentActivities: [Activity] = []


    init() {
        currentActivities = get(for: nil)
    }


    func filter(for type: Activity.ActivityType?) {
        currentActivities = get(for: type)
    }
}


// MARK: - Private

private extension Database {
    func get(for type: Activity.ActivityType?) -> [Activity] {
//        guard let type = type else {
//            return Activity.dummyActivities
//        }
//        return Activity.dummyActivities.filter({ $0.type == type })
        return []
    }
}
