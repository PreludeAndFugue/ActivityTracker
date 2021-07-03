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
    @StateObject var fitReader = FitReader.shared


    var body: some Scene {
        WindowGroup {
            MainView()
                .toolbar() {
                    ToolbarItemGroup(placement: .destructiveAction) {
                        Button(action: {}) {
                            Image(systemName: "trash")
                        }
                    }
                    
                    ToolbarItemGroup(placement: .principal) {
                        Button(action: appCoordinator.startImport) {
                            Image(systemName: "square.and.arrow.down")
                        }

                        Button(action: appCoordinator.startStravaImport) {
                            Image(systemName: "square.and.arrow.down.on.square")
                        }

                        Button(action: { appCoordinator.zoomResetAction?() }) {
                            Image(systemName: "arrow.up.left.and.down.right.magnifyingglass")
                        }
                    }
                }
                .fileImporter(
                    isPresented: $appCoordinator.isImporting,
                    allowedContentTypes: appCoordinator.allowedContentTypes,
                    onCompletion: appCoordinator.importCompletion(result:)
                )
                .alert(isPresented: $appCoordinator.isError) {
                    Alert(
                        title: Text("Error"),
                        message: Text(appCoordinator.errorMessage),
                        dismissButton: .cancel()
                    )
                }
                .environmentObject(appCoordinator)
                .environmentObject(gpxReader)
                .environmentObject(fitReader)
        }
    }
}
