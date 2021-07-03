//
//  ActivityListView.swift
//  ActivityTracker
//
//  Created by gary on 23/06/2021.
//

import SwiftUI
import UniformTypeIdentifiers

import CoreGPX


struct ActivityListView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator


    var body: some View {
        List(selection: $appCoordinator.currentActivity) {
            ForEach(appCoordinator.currentActivities) { activity in
                ActivityListItemView(activity: activity)
                    .tag(activity)
            }
        }
        .frame(minWidth: 300)
    }
}


#if DEBUG
struct ActivityListView_Previews: PreviewProvider {
    private static let db = Database.dummy
    private static let appCoordinator = AppCoordinator(db: db)
    static var previews: some View {
        ActivityListView()
            .environmentObject(appCoordinator)
    }
}
#endif
