//
//  GpxReader.swift
//  ActivityTracker
//
//  Created by gary on 27/06/2021.
//

import CoreLocation
import Foundation

import CoreGPX


typealias DistanceElevation = (distance: Double, elevation: Double)

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
        return points(activity).compactMap({ coordinate(from: $0) })
    }


    func elevation(for activity: Activity) -> [DistanceElevation] {
        var elevationPoints: [DistanceElevation] = []
        var distance = 0.0
        let ps = points(activity)
            .compactMap({ LatLngElevation(point: $0) })
        if ps.isEmpty {
            return []
        }
        let first = ps.first!
        let rest = ps[1...]
        var oldLat = first.lat
        var oldLng = first.lng
        elevationPoints.append((distance: 0, elevation: first.elevation))

        for p in rest {
            let d = distanceDegrees(lat1: oldLat, lng1: oldLng, lat2: p.lat, lng2: p.lng)
            distance += d
            elevationPoints.append((distance: distance, elevation: p.elevation))
            oldLat = p.lat
            oldLng = p.lng
        }
        return elevationPoints
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


    func points(_ activity: Activity) -> [GPXTrackPoint] {
        let url = FileManager.default.url(for: activity)
        return GPXParser(withURL: url)?
            .parsedData()?
            .tracks[0]
            .segments
            .flatMap({ $0.points }) ?? []
    }
}


private struct LatLngElevation {
    let lat: Double
    let lng: Double
    let elevation: Double

    init?(point: GPXTrackPoint) {
        guard let lat = point.latitude, let lng = point.longitude, let ele = point.elevation else {
            return nil
        }
        self.lat = lat
        self.lng = lng
        self.elevation = ele
    }

    init?(lat: Double?, lng: Double?, elevation: Double?) {
        guard let lat = lat, let lng = lng, let elevation = elevation else {
            return nil
        }
        self.lat = lat
        self.lng = lng
        self.elevation = elevation
    }
}
