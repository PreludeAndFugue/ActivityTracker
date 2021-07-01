//
//  ActivityTrackerApp.swift
//  ActivityTracker
//
//  Created by gary on 23/06/2021.
//

import SwiftUI

@main
struct ActivityTrackerApp: App {
    @StateObject var appCoordinator = AppCoordinator(db: try! Database())
    @StateObject var gpxReader = GpxReader.shared


    var body: some Scene {
        WindowGroup {
            MainView(model: MainViewModel())
                .environmentObject(appCoordinator)
                .environmentObject(gpxReader)
        }
    }
}
