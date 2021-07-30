//
//  TcxReader.swift
//  ActivityTracker
//
//  Created by gary on 30/07/2021.
//

import CoreLocation
import Foundation

class TcxReader: ReaderAPI {
    static let shared = TcxReader()

    func createActivity(with url: URL) throws -> Activity {
        let destination = try FileManager.default.copyFileToSandbox(url: url)




        return Activity(
            id: UUID().uuidString,
            type: .run,
            gear: "",
            title: "",
            date: Date(),
            elapsedTime: 100,
            distance: 100,
            fileName: destination.absoluteString,
            fileType: .tcx
        )
    }


    func coordinates(for activity: Activity) -> [CLLocationCoordinate2D] {
        let f = FileManager.default.url(for: activity)
        let xml = XMLParser(contentsOf: f)
        print(xml)


        return []
    }


    func elevation(for activity: Activity) -> [DistanceElevation] {
        let f = FileManager.default.url(for: activity)




        return []
    }
}
