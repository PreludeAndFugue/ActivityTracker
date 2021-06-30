//
//  ActivityTrackerApp.swift
//  ActivityTracker
//
//  Created by gary on 23/06/2021.
//

import SwiftUI

@main
struct ActivityTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            MainView(model: MainViewModel())
        }
    }
}
