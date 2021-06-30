//
//  SidebarViewModel.swift
//  ActivityTracker
//
//  Created by gary on 25/06/2021.
//

import Combine

final class SidebarViewModel: ObservableObject {
    enum Selection {
        case allActivities
        case bike
        case run
        case activitiesWeek
        case activitiesMonth

        case statsWeek
        case statsMonth
    }

    @Published var selectionActivity: Selection? = .allActivities
}
