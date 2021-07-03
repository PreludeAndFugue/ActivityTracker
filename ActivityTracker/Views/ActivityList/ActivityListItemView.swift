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
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(activity.title)
                    .font(.headline)


                Spacer()

                Text(activity.dateString)
                    .font(.caption2)
                    .foregroundColor(Color.gray)
            }
            Text(activity.distanceInKilometres)
            Text(activity.elapsedTimeString)
        }
        .padding(4)
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
