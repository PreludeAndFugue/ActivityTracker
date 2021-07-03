//
//  FitReader.swift
//  ActivityTracker
//
//  Created by gary on 03/07/2021.
//

import Combine
import CoreLocation
import Foundation

import FitFileParser

class FitReader: ObservableObject, ReaderAPI {
    static let shared = FitReader()


    func createActivity(with url: URL) throws -> Activity {
        let destination = try FileManager.default.copyFileToSandbox(url: url)
        guard let fit = FitFile(file: url) else {
            throw ReaderError.couldNotReadData
        }
        let records = fit.messages(forMessageType: .record)
        return Activity(
            id: UUID().uuidString,
            type: .bike,
            gear: "Chromium",
            title: "To do",
            date: getDate(records: records),
            elapsedTime: getElapsedTime(records: records),
            distance: length(of: records),
            fileName: destination.absoluteString,
            fileType: .fit
        )
    }


    func coordinates(for activity: Activity) -> [CLLocationCoordinate2D] {
        let url = URL(fileURLWithPath: activity.fileName)
        var f = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        f.appendPathComponent(url.lastPathComponent)
        let fit = FitFile(file: f)
        return fit?
            .messages(forMessageType: .record)
            .compactMap({ $0.interpretedField(key: "position")?.coordinate }) ?? []
    }
}


// MARK: - Private

private extension FitReader {
    func getDate(records: [FitMessage]) -> Date {
        guard let record = records.first else {
            return Date()
        }
        return record.interpretedField(key: "timestamp")?.time ?? Date()
    }


    func getElapsedTime(records: [FitMessage]) -> TimeInterval {
        guard
            let first = records.first,
            let last = records.last,
            let t1 = first.interpretedField(key: "timestamp")?.time,
            let t2 = last.interpretedField(key: "timestamp")?.time
        else {
            return 0
        }
        return t2.timeIntervalSinceReferenceDate - t1.timeIntervalSinceReferenceDate
    }
}
