//
//  GpxReader.swift
//  ActivityTracker
//
//  Created by gary on 27/06/2021.
//

import CoreLocation
import Foundation

import CoreGPX

class GpxReader: ObservableObject, ReaderAPI {
    static let shared = GpxReader()


    func createActivity(with url: URL) throws -> Activity {
        let destination = try FileManager.default.copyFileToSandbox(url: url)
        guard let gpx = GPXParser(withURL: url)?.parsedData() else {
            throw ReaderError.couldNotReadData
        }
        if gpx.tracks.count != 1 {
            throw ReaderError.moreThanOneTrack
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
            fileName: destination.absoluteString,
            fileType: .gpx
        )
    }


    func coordinates(for activity: Activity) -> [CLLocationCoordinate2D] {
        let url = URL(fileURLWithPath: activity.fileName)
        var x = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        x.appendPathComponent(url.lastPathComponent)
        let data = GPXParser(withURL: x)?
            .parsedData()?
            .tracks[0]
            .segments
            .flatMap({ $0.points })
            .compactMap({ coordinate(from: $0 )}) ?? []
        return data
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


    func coordinate(from point: GPXTrackPoint) -> CLLocationCoordinate2D? {
        guard let lat = point.latitude, let lng = point.longitude else { return nil }
        return CLLocationCoordinate2D(latitude: lat, longitude: lng)
    }
}
