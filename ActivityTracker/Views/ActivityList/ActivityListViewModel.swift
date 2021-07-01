//
//  ActivityListViewModel.swift
//  ActivityTracker
//
//  Created by gary on 27/06/2021.
//

import Combine
import Foundation

final class ActivityListViewModel: ObservableObject {
    let appCoordinator: AppCoordinator

    @Published var selectedActivity: Activity? = nil


    var currentActivities: [Activity] {
        appCoordinator.db.currentActivities
    }


    init(appCoordinator: AppCoordinator) {
        self.appCoordinator = appCoordinator
        selectedActivity = appCoordinator.firstActivity
    }


    func startImport() {
        appCoordinator.startImport()
    }
}
