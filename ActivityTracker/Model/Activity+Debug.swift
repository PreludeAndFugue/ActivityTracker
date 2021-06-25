//
//  Activity+Debug.swift
//  ActivityTracker
//
//  Created by gary on 25/06/2021.
//

#if DEBUG
extension Activity {
    static let dummy1 = dummy(n: 1)

    static let dummyActivities = (1...10).map({ dummy(n: $0 )})


    private static func dummy(n: Int) -> Activity {
        Activity(
            id: "\(n)",
            type: .allCases.randomElement()!,
            title: "Activity \(n)",
            date: "06-06-2021"
        )
    }
}
#endif
