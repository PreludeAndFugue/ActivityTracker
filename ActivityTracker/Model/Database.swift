//
//  Database.swift
//  ActivityTracker
//
//  Created by gary on 25/06/2021.
//

import Combine
import Foundation

import GRDB

final class Database: ObservableObject {
    enum Error: Swift.Error {
        case noAccessToDocumentFolder
    }

    private static let fileName = "ActivityTracker.sqlite"

    private let queue: DatabaseQueue

    @Published var currentActivities: [Activity] = []


    init(inMemory: Bool = false) throws {
        if inMemory {
            queue = DatabaseQueue()
        } else {
            queue = try DatabaseQueue(path: Self.path())
        }
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
    static func path() throws -> String {
        guard var destination = FileManager.default.documentDirectory else {
            throw Error.noAccessToDocumentFolder
        }
        destination.appendPathComponent(fileName)
        return destination.absoluteString
    }


    func get(for type: Activity.ActivityType?) -> [Activity] {
        return try! queue.read() { db in
            try Activity.all()
                .order(Activity.Columns.date.desc)
                .fetchAll(db)
        }
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
            }
        }
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
