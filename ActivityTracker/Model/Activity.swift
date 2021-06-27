//
//  Activity.swift
//  ActivityTracker
//
//  Created by gary on 25/06/2021.
//

import Foundation

import GRDB

private var dateFormatter: DateFormatter = {
    var df = DateFormatter()
    df.dateStyle = .medium
    df.timeStyle = .short
    return df
}()

struct Activity: Identifiable, Codable {
    let id: String
    let type: ActivityType
    let gear: String
    let title: String
    let date: Date
    let elapsedTime: TimeInterval
    let distance: Double
    let fileName: String

    var dateString: String {
        dateFormatter.string(from: date)
    }
}


extension Activity {
    enum ActivityType: String, CaseIterable, Codable {
        case bike
        case run

        var title: String {
            switch self {
            case .bike: return "bike"
            case .run: return "run"
            }
        }
    }
}


// MARK: - FetchableRecord

extension Activity: FetchableRecord {
}


// MARK: - TableRecord

extension Activity: TableRecord {
    enum Columns: String, ColumnExpression {
        case id
        case type
        case gear
        case title
        case date
        case elapsedTime
        case distance
        case fileName
    }
}


// MARK: - Persistable

extension Activity: PersistableRecord {
}
