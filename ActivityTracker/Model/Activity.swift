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

        var title: String {
            switch self {
            case .bike: return "bike"
            case .run: return "run"
            }
        }
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
    }
}


// MARK: - Formatters

private var dateFormatter: DateFormatter = {
    var df = DateFormatter()
    df.dateStyle = .medium
    df.timeStyle = .short
    return df
}()

private var elapsedTimeFormatter: DateComponentsFormatter = {
    var df = DateComponentsFormatter()
    df.allowedUnits = [.hour, .minute, .second]
    df.maximumUnitCount = 2
    df.unitsStyle = .abbreviated
    return df
}()

private var distanceFormatter: MeasurementFormatter = {
    var nf = NumberFormatter()
    nf.numberStyle = .decimal
    nf.maximumFractionDigits = 2
    var mf = MeasurementFormatter()
    mf.unitOptions = .providedUnit
    mf.unitStyle = .short
    mf.numberFormatter = nf
    return mf
}()
