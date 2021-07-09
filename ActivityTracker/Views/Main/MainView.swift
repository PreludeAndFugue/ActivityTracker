//
//  ContentView.swift
//  ActivityTracker
//
//  Created by gary on 23/06/2021.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    
    var body: some View {
        NavigationView {
            if appCoordinator.isShowingActivities {
                SidebarView()
                ActivityListView()
                ActivityDetailView()
            } else {
                SidebarView()
                StatisticsView(model: StatisticsViewModel(db: appCoordinator.db))
            }
        }
    }
}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
