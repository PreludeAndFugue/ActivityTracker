//
//  SidebarView.swift
//  ActivityTracker
//
//  Created by gary on 23/06/2021.
//

import SwiftUI

struct SidebarView: View {
    @State var selection: Int? = nil

    var body: some View {
        List(selection: $selection) {
            Section(header: Text("Activities")) {
                Text("All activities").tag(1)
                Text("Bike").tag(2)
            }

            Section(header: Text("Dates")) {
                Text("This week").tag(3)
                Text("This month").tag(4)
            }
        }
        .listStyle(SidebarListStyle())
        .toolbar {
            ToolbarItem(id: "test", placement: .automatic) {
                Button(action: {}) {
                    Image(systemName: "plus")
                }
            }
        }

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
