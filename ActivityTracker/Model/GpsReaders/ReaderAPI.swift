//
//  ReaderAPI.swift
//  ActivityTracker
//
//  Created by gary on 03/07/2021.
//

import CoreLocation
import Foundation

enum ReaderError: Error {
    case noAccessToDocumentFolder
    case couldNotSaveFile
    case couldNotReadData
    case moreThanOneTrack
}

protocol ReaderAPI {
    func createActivity(with url: URL) throws -> Activity
    func coordinates(for activity: Activity) -> [CLLocationCoordinate2D]
    func elevation(for activity: Activity) -> [DistanceElevation]
}
