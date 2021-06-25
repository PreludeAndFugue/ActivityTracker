//
//  Activity.swift
//  ActivityTracker
//
//  Created by gary on 25/06/2021.
//

struct Activity: Identifiable {
    let id: String
    let type: ActivityType
    let title: String
    let date: String
}


extension Activity {
    enum ActivityType: CaseIterable {
        case bike
        case run

        var title: String {
            switch self {
            case .bike: return "bike"
            case .run: return "run"
            }
        }
    }
}
