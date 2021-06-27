//
//  ActivityDetailView.swift
//  ActivityTracker
//
//  Created by gary on 23/06/2021.
//

import MapKit
import SwiftUI

struct ActivityDetailView: View {
    @EnvironmentObject var gpxReader: GpxReader
    @StateObject var model: ActivityDetailViewModel


    var body: some View {
        ActivityDetailMap(activity: model.activity, gpxReader: gpxReader)
            .overlay(overlay, alignment: .topLeading)
    }
}


// MARK: - Private

private extension ActivityDetailView {
    var overlay: some View {
        VStack(alignment: .leading, spacing: 4) {
            Button(action: model.toggleDetails) {
                HStack {
                    Image(systemName: "chevron.down")
                        .rotationEffect(model.chevronAngle)
                    Text(model.disclosureText)
                }
            }
            if model.isShowingDetails {
                Text(model.activity.title)
                Text(model.activity.dateString)
                Text("Type: \(model.activity.type.title)")
                Text("Gear: \(model.activity.gear)")
                Text("Distance: \(model.activity.distanceInKilometres)")
                Text("Duration: \(model.activity.elapsedTimeString)")
            }
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
        ActivityDetailView(model: .init(activity: .dummy1))
            .frame(width: 600, height: 600)
            .environmentObject(GpxReader.shared)
    }
}
#endif
