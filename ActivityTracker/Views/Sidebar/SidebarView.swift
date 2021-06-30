//
//  SidebarView.swift
//  ActivityTracker
//
//  Created by gary on 23/06/2021.
//

import SwiftUI

struct SidebarView: View {
    @EnvironmentObject var db: Database
    @StateObject var vm = SidebarViewModel()


    var body: some View {
        VStack {
            List(selection: $vm.selectionActivity) {
                Section(header: Text("Activities")) {
                    Text("All activities")
                        .tag(SidebarViewModel.SelectionActivity.all)
                    Text("Bike")
                        .tag(SidebarViewModel.SelectionActivity.bike)
                    Text("Run")
                        .tag(SidebarViewModel.SelectionActivity.run)
                }
            }

            List(selection: $vm.selectionDuration) {
                Section(header: Text("Dates")) {
                    Text("This week").tag(4)
                    Text("This month").tag(5)
                }
            }

            Spacer()
        }
        .onChange(of: vm.selectionActivity, perform: { selection in
            let activityType = vm.activityType(selection: selection)
            db.filter(for: activityType)
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
