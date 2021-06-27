//
//  ActivityDetailView.swift
//  ActivityTracker
//
//  Created by gary on 23/06/2021.
//

import MapKit
import SwiftUI

struct ActivityDetailView: View {
    let activity: Activity


    var body: some View {
        ActivityDetailMap(activity: activity)
            .overlay(overlay, alignment: .topLeading)
    }
}


// MARK: - Private

private extension ActivityDetailView {
    var overlay: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(activity.title)
            Text(activity.dateString)
            Text("Type: \(activity.type.title)")
            Text("Gear: \(activity.gear)")
            Text("Distance: \(activity.distanceInKilometres)")
            Text("Duration: \(activity.elapsedTimeString)")
        }
        .padding()
        .background(Color.init(.sRGB, white: 0, opacity: 0.4))
        .cornerRadius(8)
        .padding(10)
    }
}


#if DEBUG
struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailView(activity: .dummy1)
            .frame(width: 600, height: 600)
    }
}
#endif
