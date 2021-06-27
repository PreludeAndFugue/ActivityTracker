//
//  ActivityListItemView.swift
//  ActivityTracker
//
//  Created by gary on 25/06/2021.
//

import SwiftUI

struct ActivityListItemView: View {
    let activity: Activity

    var body: some View {
        NavigationLink(
            destination: ActivityDetailView(activity: activity),
            label: {
                VStack(alignment: .leading) {
                    HStack {
                        Text(activity.title)

                        Spacer()

                        Text(activity.dateString)
                    }
                    Text("Type: \(activity.type.title)")
                }
            })
    }
}


#if DEBUG
struct ActivityListItemView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            ActivityListItemView(activity: .dummy1)
                .frame(width: 350, height: 150)
        }
    }
}
#endif
