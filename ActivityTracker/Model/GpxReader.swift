//
//  GpxReader.swift
//  ActivityTracker
//
//  Created by gary on 27/06/2021.
//

import Foundation

import CoreGPX

class GpxReader {
    enum Error: Swift.Error {
        case couldNotReadData
        case moreThanOneTrack
    }


    static let shared = GpxReader()


    func createActivity(with url: URL) throws -> Activity {
        guard let gpx = GPXParser(withURL: url)?.parsedData() else {
            throw Error.couldNotReadData
        }
        if gpx.tracks.count != 1 {
            throw Error.moreThanOneTrack
        }
        let track = gpx.tracks[0]
        let points = track.segments.flatMap({ $0.points })
        return Activity(
            id: UUID().uuidString,
            type: .bike,
            gear: "Chromium",
            title: gpx.metadata?.name ?? "Unknown",
            date: gpx.metadata?.time ?? Date(),
            elapsedTime: getElapsedTime(points: points),
            distance: length(of: points),
            fileName: url.absoluteString
        )
    }
}


// MARK: - Private

private extension GpxReader {
    func getElapsedTime(points: [GPXWaypoint]) -> TimeInterval {
        guard let first = points.first, let last = points.last else {
            return 0
        }
        guard let t1 = first.time, let t2 = last.time else {
            return 0
        }
        return t2.timeIntervalSinceReferenceDate - t1.timeIntervalSinceReferenceDate
    }
}
