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
}


extension ReaderAPI {
    func saveFileToSandbox(url: URL) throws -> URL {
        let fm = FileManager.default
        guard var destination = fm.documentDirectory else {
            throw ReaderError.noAccessToDocumentFolder
        }
        destination.appendPathComponent(url.lastPathComponent)
        do {
            try FileManager.default.copyItem(at: url, to: destination)
        }
        return destination
    }
}
