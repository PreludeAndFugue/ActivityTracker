//
//  ContentView.swift
//  ActivityTracker
//
//  Created by gary on 23/06/2021.
//

import SwiftUI

struct MainView: View {
    private let db = Database()
    
    var body: some View {
        NavigationView {
            SidebarView()
            ActivityListView()
            ActivityDetailView(activity: .dummy1)
        }
        .environmentObject(Database())
    }
}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
