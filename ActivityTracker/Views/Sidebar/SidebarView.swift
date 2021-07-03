//
//  SidebarView.swift
//  ActivityTracker
//
//  Created by gary on 23/06/2021.
//

import SwiftUI

struct SidebarView: View {
    enum Selection {
        case allActivities
        case bike
        case run
        case walk

        case activitiesWeek
        case activitiesMonth

        case statsWeek
        case statsMonth
    }

    @EnvironmentObject var coordinator: AppCoordinator


    var body: some View {
        VStack {
            List(selection: $coordinator.sidebarSelection) {
                Section(header: Text("Activities")) {
                    Text("All activities")
                        .tag(SidebarView.Selection.allActivities)
                    Text("Bike")
                        .tag(SidebarView.Selection.bike)
                    Text("Run")
                        .tag(SidebarView.Selection.run)
                    Text("Walk")
                        .tag(SidebarView.Selection.walk)
                    Text("This week")
                        .tag(SidebarView.Selection.activitiesWeek)
                    Text("This month")
                        .tag(SidebarView.Selection.activitiesMonth)
                }

                Section(header: Text("Statistics")) {
                    Text("This week").tag(SidebarView.Selection.statsWeek)
                    Text("This month").tag(SidebarView.Selection.statsMonth)
                }
            }

            Spacer()
        }
        .onChange(of: coordinator.sidebarSelection, perform: { selection in
            coordinator.sidebar()
        })
        .listStyle(SidebarListStyle())
        .frame(idealWidth: 200)
    }
}


extension SidebarView.Selection {
    var isShowingActivities: Bool {
        switch self {
        case .allActivities, .bike, .run, .walk, .activitiesWeek, .activitiesMonth:
            return true
        case .statsWeek, .statsMonth:
            return false
        }
    }
}


#if DEBUG
struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
#endif
