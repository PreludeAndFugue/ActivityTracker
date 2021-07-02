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
                .toolbar() {
                    ToolbarItem(placement: .principal) {
                        Button(action: appCoordinator.startImport) {
                            Image(systemName: "square.and.arrow.down")
                        }
                    }
                    ToolbarItem(placement: .status) {
                        Button(action: { appCoordinator.zoomResetAction?() }) {
                            Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                    }
                }
                .environmentObject(appCoordinator)
                .environmentObject(gpxReader)
        }
    }
}
