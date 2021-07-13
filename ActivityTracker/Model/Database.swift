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
        static let zero = ActivityCount(all: 0, bike: 0, run: 0, walk: 0)
        let all: Int
        let bike: Int
        let run: Int
        let walk: Int
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


    func stats(for date: Date) -> Statistics {
        let weekInterval = Calendar.current.weekInterval(containing: date)
        let monthInterval = Calendar.current.monthInterval(containing: date)
        let yearInterval = Calendar.current.yearInterval(containing: date)
        return try! queue.read() { db in
            let weekActivities = try Activity.all()
                .filter(Activity.Columns.date >= weekInterval.start && Activity.Columns.date < weekInterval.end)
                .fetchAll(db)
            let week = Statistics.IntervalActivities(dateInterval: weekInterval, activities: weekActivities)

            let monthActivities = try Activity.all()
                .filter(Activity.Columns.date >= monthInterval.start && Activity.Columns.date < monthInterval.end)
                .fetchAll(db)
            let month = Statistics.IntervalActivities(dateInterval: monthInterval, activities: monthActivities)


            let yearActivities = try Activity.all()
                .filter(Activity.Columns.date >= yearInterval.start && Activity.Columns.date < yearInterval.end)
                .fetchAll(db)
            let year = Statistics.IntervalActivities(dateInterval: yearInterval, activities: yearActivities)

            return Statistics(week: week, month: month, year: year)
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
                run: try Activity.all().filter(type: .run).fetchCount(db),
                walk: try Activity.all().filter(type: .walk).fetchCount(db)
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

    static var dummy: Database = {
        let db = Database(dummy: true)
        let date = Date()
        let activities: [Activity] = (-15...15).enumerated().compactMap({
            guard [true, true, true, false].randomElement()! else { return nil }
            return Activity(
                id: UUID().uuidString,
                type: .bike,
                gear: "CHR",
                title: "Afternoon ride",
                date: Calendar.current.date(byAdding: .day, value: $0.element, to: date)!,
                elapsedTime: [2800, 3000, 3500, 3987, 4343].randomElement()!,
                distance: [5_123, 15_873, 32_343, 50_334, 90_343].randomElement()!,
                fileName: "",
                fileType: .gpx
            )
        })
        db.create(activities)
        return db
    }()
}
#endif
