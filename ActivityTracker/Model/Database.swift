//
//  Database.swift
//  ActivityTracker
//
//  Created by gary on 25/06/2021.
//

import Combine

import GRDB

final class Database: ObservableObject {
    private let queue: DatabaseQueue

    @Published var currentActivities: [Activity] = []


    init() {
        queue = DatabaseQueue()
        createActivityTable()
        currentActivities = get(for: nil)
    }


    func filter(for type: Activity.ActivityType?) {
        currentActivities = get(for: type)
    }


    func create(_ activity: Activity) {
        try! queue.write() { db in
            try activity.insert(db)
        }
        currentActivities = get(for: nil)
    }
}


// MARK: - Private

private extension Database {
    func get(for type: Activity.ActivityType?) -> [Activity] {
//        guard let type = type else {
//            return Activity.dummyActivities
//        }
//        return Activity.dummyActivities.filter({ $0.type == type })
        return try! queue.read() { db in
            try Activity.fetchAll(db)
        }
    }


    func createActivityTable() {
        try! queue.write() { db in
            try db.create(table: "activity") { t in
                t.column(Activity.Columns.id.rawValue, .text)
                t.column(Activity.Columns.type.rawValue, .text)
                t.column(Activity.Columns.gear.rawValue, .text)
                t.column(Activity.Columns.title.rawValue, .text)
                t.column(Activity.Columns.date.rawValue, .date)
                t.column(Activity.Columns.elapsedTime.rawValue, .double)
                t.column(Activity.Columns.distance.rawValue, .double)
                t.column(Activity.Columns.fileName.rawValue, .text)
            }
        }
    }
}
