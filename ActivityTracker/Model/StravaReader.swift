//
//  StravaReader.swift
//  ActivityTracker
//
//  Created by gary on 03/07/2021.
//

import Combine
import Foundation

import SwiftCSV

/// Import a Strava export.
///
/// Reads the Strava export activities.csv file.
final class StravaReader: ObservableObject {
    enum Error: Swift.Error {
        case incorrectColumns
    }

    enum Columns: Int, CaseIterable {
        case activityName = 2
        case activityType = 3
        case activityGear = 9
        case fileName = 10
        case elapsedTime = 13
        case movingTime = 14
        case distance = 15
        case elevationGain = 18
        case elevationLoss = 19
    }


    static let shared = StravaReader()


    func createActivities(with directoryUrl: URL) throws -> [Activity] {
        let activitiesUrl = directoryUrl.appendingPathComponent("activities.csv")
        let csv: CSV
        do {
            csv = try CSV(url: activitiesUrl)
        } catch {
            throw ReaderError.couldNotReadData
        }
        try checkColumns(csv: csv)

        let count = csv.enumeratedRows.count

        let activityTypes = Set(csv.enumeratedRows.map({ $0[Columns.activityType.rawValue] }))
        print(activityTypes)

        var activities: [Activity] = []
        for row in csv.enumeratedRows {
            activities.append(try activity(from: row, csvUrl: activitiesUrl))
        }
        return activities
    }
}


// MARK: - Private

private extension StravaReader {
    func checkColumns(csv: CSV) throws {
        for column in Columns.allCases {
            if csv.header[column.rawValue] != column.name {
                throw Error.incorrectColumns
            }
        }
    }


    func activity(from row: [String], csvUrl: URL) throws -> Activity {
        let destination = try copyFile(row, csvUrl: csvUrl)
        return Activity(
            id: UUID().uuidString,
            type: activityType(from: row[Columns.activityType.rawValue]),
            gear: row[Columns.activityGear.rawValue],
            title: row[Columns.activityName.rawValue],
            date: Date(),
            elapsedTime: Double(row[Columns.elapsedTime.rawValue]) ?? 0,
            distance: Double(row[Columns.distance.rawValue]) ?? 0,
            fileName: destination?.absoluteString ?? "",
            fileType: destination?.fileType
        )
    }


    func copyFile(_ row: [String], csvUrl: URL) throws -> URL? {
        let fileName = row[Columns.fileName.rawValue]
        if fileName == "" { return nil }
        let path = csvUrl.deletingLastPathComponent().appendingPathComponent(fileName)
        do {
            let destination = try FileManager.default.copyFileToSandbox(url: path)
            return destination
        } catch let error {
            print(error)
            return nil
        }
    }


    func activityType(from string: String) -> Activity.ActivityType {
        switch string {
        case "Ride": return .bike
        case "Run": return .run
        case "Walk": return .walk
        default: return .unknown
        }
    }
}


extension StravaReader.Columns {
    var name: String {
        switch self {
        case .activityName: return "Activity Name"
        case .activityType: return "Activity Type"
        case .activityGear: return "Activity Gear"
        case .fileName: return "Filename"
        case .elapsedTime: return "Elapsed Time"
        case .movingTime: return "Moving Time"
        case .distance: return "Distance"
        case .elevationGain: return "Elevation Gain"
        case .elevationLoss: return "Elevation Loss"
        }
    }
}
