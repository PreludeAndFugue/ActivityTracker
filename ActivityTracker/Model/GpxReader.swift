//
//  GpxReader.swift
//  ActivityTracker
//
//  Created by gary on 27/06/2021.
//

import CoreLocation
import Foundation

import CoreGPX

class GpxReader: ObservableObject {
    enum Error: Swift.Error {
        case couldNotSaveFile
        case couldNotReadData
        case moreThanOneTrack
    }


    static let shared = GpxReader()


    func createActivity(with url: URL) throws -> Activity {
        guard let destination = saveFileToSandbox(url: url) else {
            throw Error.couldNotSaveFile
        }
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
            fileName: destination.absoluteString
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


    func saveFileToSandbox(url: URL) -> URL? {
        let fm = FileManager.default
        guard var destination = fm.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return nil
        }
        destination.appendPathComponent(url.lastPathComponent)
        try! FileManager.default.copyItem(at: url, to: destination)
        return destination
    }
}
