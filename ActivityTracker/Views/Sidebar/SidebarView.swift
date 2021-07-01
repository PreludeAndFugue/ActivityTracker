//
//  SidebarView.swift
//  ActivityTracker
//
//  Created by gary on 23/06/2021.
//

import SwiftUI

struct SidebarView: View {
    @StateObject var vm = SidebarViewModel()


    var body: some View {
        VStack {
            List(selection: $vm.selectionActivity) {
                Section(header: Text("Activities")) {
                    Text("All activities")
                        .tag(SidebarViewModel.Selection.allActivities)
                    Text("Bike")
                        .tag(SidebarViewModel.Selection.bike)
                    Text("Run")
                        .tag(SidebarViewModel.Selection.run)
                    Text("This week")
                        .tag(SidebarViewModel.Selection.activitiesWeek)
                    Text("This month")
                        .tag(SidebarViewModel.Selection.activitiesMonth)
                }

                Section(header: Text("Statistics")) {
                    Text("This week").tag(SidebarViewModel.Selection.statsWeek)
                    Text("This month").tag(SidebarViewModel.Selection.statsMonth)
                }
            }

            Spacer()
        }
        .onChange(of: vm.selectionActivity, perform: { selection in
            print("update sidebar selection")
        })
        .listStyle(SidebarListStyle())
        .frame(idealWidth: 200)
    }
}


#if DEBUG
struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
#endif
