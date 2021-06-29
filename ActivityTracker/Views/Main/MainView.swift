//
//  ContentView.swift
//  ActivityTracker
//
//  Created by gary on 23/06/2021.
//

import SwiftUI

struct MainView: View {
    private let db = try! Database()
    private let gpxReader = GpxReader.shared
    
    var body: some View {
        NavigationView {
            SidebarView()
            ActivityListView(model: ActivityListViewModel(db: db))
            ActivityDetailView(model: .init(activity: .dummy1))
        }
        .environmentObject(gpxReader)
        .environmentObject(db)
    }
}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MainView()
    }
}
#endif
