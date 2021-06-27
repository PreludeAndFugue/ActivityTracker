//
//  Activity+Debug.swift
//  ActivityTracker
//
//  Created by gary on 25/06/2021.
//

#if DEBUG

import Foundation

extension Activity {
    static let dummy1 = dummy(n: 1)

    static let dummyActivities = (1...10).map({ dummy(n: $0 )})


    private static func dummy(n: Int) -> Activity {
        Activity(
            id: "\(n)",
            type: .allCases.randomElement()!,
            gear: "Chromium",
            title: "Activity \(n)",
            date: Date(),
            elapsedTime: 1000,
            distance: 10_000,
            fileName: "filename.gpx"
        )
    }
}
#endif
