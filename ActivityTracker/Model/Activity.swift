//
//  Activity.swift
//  ActivityTracker
//
//  Created by gary on 25/06/2021.
//

import Foundation

import GRDB


struct Activity: Identifiable, Codable {
    let id: String
    let type: ActivityType
    let gear: String
    let title: String
    let date: Date
    let elapsedTime: TimeInterval
    let distance: Double
    let fileName: String
    let fileType: URL.FileType?


    var dateString: String {
        dateFormatter.string(from: date)
    }


    var elapsedTimeString: String {
        return elapsedTimeFormatter.string(from: elapsedTime) ?? "00:00"
    }


    var distanceInKilometres: String {
        let m = Measurement(value: distance, unit: UnitLength.meters)
        return distanceFormatter.string(from: m.converted(to: .kilometers))
    }
}


extension Activity {
    enum ActivityType: String, CaseIterable, Codable {
        case bike
        case run
        case walk
        case unknown

        var title: String {
            switch self {
            case .bike: return "bike"
            case .run: return "run"
            case .walk: return "walk"
            case .unknown: return "unknown"
            }
        }
    }
}


extension Activity: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}


// MARK: - GRDB

extension Activity: FetchableRecord, TableRecord, PersistableRecord {
    enum Columns: String, ColumnExpression {
        case id
        case type
        case gear
        case title
        case date
        case elapsedTime
        case distance
        case fileName
        case fileType
    }
}
