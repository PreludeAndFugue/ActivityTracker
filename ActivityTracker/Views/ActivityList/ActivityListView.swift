//
//  ActivityListView.swift
//  ActivityTracker
//
//  Created by gary on 23/06/2021.
//

import SwiftUI

struct ActivityListView: View {
    @EnvironmentObject var db: Database


    var body: some View {
        List(db.currentActivities) { activity in
            ActivityListItemView(activity: activity)
        }
        .toolbar {
            Button(action: {}) {
                Image(systemName: "square.and.arrow.up")
            }
            Button(action: {}) {
                Image(systemName: "square.and.arrow.down")
            }
        }
        .frame(minWidth: 250)
    }
}


#if DEBUG
struct ActivityListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListView()
    }
}
#endif
