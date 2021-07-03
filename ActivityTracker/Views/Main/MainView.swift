//
//  ContentView.swift
//  ActivityTracker
//
//  Created by gary on 23/06/2021.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator

    @StateObject var model: MainViewModel
    
    var body: some View {
        NavigationView {
            SidebarView()
            ActivityListView(
                model: ActivityListViewModel(appCoordinator: appCoordinator),
                activity: $model.selectedActivity
            )
            ActivityDetailView(activity: $model.selectedActivity)
        }
        .onAppear() {
            model.selectedActivity = appCoordinator.firstActivity
        }
    }
}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView(model: MainViewModel())
    }
}
#endif
