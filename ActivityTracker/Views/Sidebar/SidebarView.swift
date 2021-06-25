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
                    Text("All activities").tag(1)
                    Text("Bike").tag(2)
                    Text("Run").tag(3)
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
        .listStyle(SidebarListStyle())
        .frame(width: 200)
    }
}


#if DEBUG
struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        SidebarView()
    }
}
#endif
