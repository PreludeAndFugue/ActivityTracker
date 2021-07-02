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
    @StateObject var model: ActivityListViewModel
    @Binding var activity: Activity?


    var body: some View {
        List(selection: $activity) {
            ForEach(model.currentActivities) { activity in
                ActivityListItemView(activity: activity)
                    .tag(activity)
            }
        }
        .frame(idealWidth: 300)
    }
}


#if DEBUG
struct ActivityListView_Previews: PreviewProvider {
    private static let db = Database.dummy
    private static let appCoordinator = AppCoordinator(db: db)
    private static let model = ActivityListViewModel(appCoordinator: appCoordinator)
    static var previews: some View {
        ActivityListView(model: model, activity: .constant(nil))
    }
}
#endif
