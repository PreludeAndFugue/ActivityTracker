//
//  Database.swift
//  ActivityTracker
//
//  Created by gary on 25/06/2021.
//

import Foundation

import GRDB

final class Database {
    enum Error: Swift.Error {
        case noAccessToDocumentFolder
    }


    struct ActivityCount {
        static let zero = ActivityCount(all: 0, bike: 0, run: 0)
        let all: Int
        let bike: Int
        let run: Int
    }

    private static let fileName = "ActivityTracker.sqlite"

    private let queue: DatabaseQueue


    init(inMemory: Bool = false) throws {
        if inMemory {
            queue = DatabaseQueue()
        } else {
            queue = try DatabaseQueue(path: Self.path())
        }
        createActivityTable()
    }


    func get(for type: Activity.ActivityType?) -> [Activity] {
        return try! queue.read() { db in
            try Activity.all()
                .filter(type: type)
                .order(Activity.Columns.date.desc)
                .fetchAll(db)
        }
    }


    func get(for dateInterval: DateInterval) -> [Activity] {
        return try! queue.read() { db in
            try Activity.all()
                .filter(Activity.Columns.date >= dateInterval.start && Activity.Columns.date < dateInterval.end)
                .fetchAll(db)
        }
    }


    func stats(for dateInterval: DateInterval) -> Statistics {
        return try! queue.read() { db in
            let activities = try Activity.all()
                .filter(Activity.Columns.date >= dateInterval.start && Activity.Columns.date < dateInterval.end)
                .fetchAll(db)
            return Statistics(dateInterval: dateInterval, activities: activities)
        }
    }


    func create(_ activity: Activity) {
        try! queue.write() { db in
            try activity.insert(db)
        }
    }


    func create(_ activities: [Activity]) {
        try! queue.write() { db in
            for activity in activities {
                try activity.insert(db)
            }
        }
    }


    func activityCount() -> ActivityCount {
        return try! queue.read() { db in
            ActivityCount(
                all: try Activity.fetchCount(db),
                bike: try Activity.all().filter(type: .bike).fetchCount(db),
                run: try Activity.all().filter(type: .run).fetchCount(db)
            )
        }
    }
}


// MARK: - Private

private extension Database {
    static func path() throws -> String {
        guard var destination = FileManager.default.documentDirectory else {
            throw Error.noAccessToDocumentFolder
        }
        destination.appendPathComponent(fileName)
        return destination.absoluteString
    }


    func createActivityTable() {
        try! queue.write() { db in
            try db.create(table: "activity", ifNotExists: true) { t in
                t.column(Activity.Columns.id.rawValue, .text)
                t.column(Activity.Columns.type.rawValue, .text)
                t.column(Activity.Columns.gear.rawValue, .text)
                t.column(Activity.Columns.title.rawValue, .text)
                t.column(Activity.Columns.date.rawValue, .date)
                t.column(Activity.Columns.elapsedTime.rawValue, .double)
                t.column(Activity.Columns.distance.rawValue, .double)
                t.column(Activity.Columns.fileName.rawValue, .text)
                t.column(Activity.Columns.fileType.rawValue, .text)
            }
        }
    }
}


extension DerivableRequest where RowDecoder == Activity {
    func filter(type: Activity.ActivityType?) -> Self {
        guard let type = type else {
            return self
        }
        return filter(Activity.Columns.type == type.rawValue)
    }
}


#if DEBUG
extension Database {
    convenience init(dummy: Bool = true) {
        try! self.init(inMemory: true)
    }

    static let dummy = Database(dummy: true)
}
#endif
