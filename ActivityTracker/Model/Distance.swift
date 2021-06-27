//
//  Distance.swift
//  ActivityTracker
//
//  Created by gary on 27/06/2021.
//

import Foundation

import CoreGPX

/// Approximation of the Earth's radius in kilometres
private let r = 6_371.0


private func radians(_ angle: Double) -> Double {
    return Double.pi * angle / 180.0
}


/// Haversine function
///
/// https://en.wikipedia.org/wiki/Haversine_formula
///
/// - parameters:
///     - theta: angle in radians
private func hav(theta: Double) -> Double {
    let x = sin(theta/2)
    return x*x
}


/// Haverine distance between two points
///
/// - parameters:
///     - lat1: latitude of first point in radians
///     - lng1: longitude of first point in radians
///     - lat2: latitude of second point in radians
///     - lng2: longitude of second point in radians
/// - returns:
///     Distance in metres
func distance(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Double {
    let x = hav(theta: lat2 - lat1) + cos(lat1)*cos(lat2)*hav(theta: lng2 - lng1)
    return 2_000*r*asin(sqrt(x))
}


/// Haverine distance between two points
///
/// - parameters:
///     - lat1: latitude of first point in degrees
///     - lng1: longitude of first point in degrees
///     - lat2: latitude of second point in degrees
///     - lng2: longitude of second point in degrees
/// - returns:
///     Distance in metres
func distanceDegrees(lat1: Double, lng1: Double, lat2: Double, lng2: Double) -> Double {
    let lat1Radians = radians(lat1)
    let lng1Radians = radians(lng1)
    let lat2Radians = radians(lat2)
    let lng2Radians = radians(lng2)
    return distance(lat1: lat1Radians, lng1: lng1Radians, lat2: lat2Radians, lng2: lng2Radians)
}


private struct Point {
    let lat: Double
    let lng: Double

    init?(point: GPXWaypoint) {
        guard let lat = point.latitude, let lng = point.longitude else { return nil }
        self.lat = lat
        self.lng = lng
    }
}

/// Length of a `List` of `TrackPoint`s
///
/// - parameters:
///     - points: a `List` of `TrackPoint` objects.
/// - returns:
///     Length in metres
func length(of points: [GPXWaypoint]) -> Double {
    let validPoints = points.compactMap({ Point(point: $0) })
    var result = 0.0
    if points.isEmpty {
        return result
    }
    for (p1, p2) in zip(validPoints, validPoints[1...]) {
        result += distanceDegrees(
            lat1: p1.lat,
            lng1: p1.lng,
            lat2: p2.lat,
            lng2: p2.lng
        )
    }
    return result
}
