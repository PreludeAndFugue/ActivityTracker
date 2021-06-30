//
//  ContentView.swift
//  ActivityTracker
//
//  Created by gary on 23/06/2021.
//

import SwiftUI

struct MainView: View {
    private let db = try! Database()
    private let gpxReader = GpxReader.shared

    @StateObject var model: MainViewModel
    
    var body: some View {
        NavigationView {
            SidebarView()
            ActivityListView(
                model: ActivityListViewModel(db: db),
                activity: $model.selectedActivity
            )
            ActivityDetailView(
                model: ActivityDetailViewModel(),
                activity: $model.selectedActivity
            )
        }
        .onAppear() {
            model.selectedActivity = db.currentActivities.first
        }
        .environmentObject(gpxReader)
        .environmentObject(db)
    }
}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(model: MainViewModel())
    }
}
#endif
