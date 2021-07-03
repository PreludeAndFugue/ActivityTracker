//
//  ActivityDetailView.swift
//  ActivityTracker
//
//  Created by gary on 23/06/2021.
//

import MapKit
import SwiftUI

struct ActivityDetailView: View {
    @EnvironmentObject var appCoordinator: AppCoordinator
    @Binding var activity: Activity?

    var body: some View {
        ActivityDetailMap(activity: activity)
            .overlay(overlay, alignment: .topLeading)
    }
}


// MARK: - Private

private extension ActivityDetailView {
    var overlay: some View {

        DisclosureGroup("Activity information") {
            HStack {
                VStack(alignment: .leading) {
                    Text(activity?.title ?? "")
                    Text(activity?.dateString ?? "")
                    Text("Type: " + (activity?.type.title ?? ""))
                    Text("Gear: " + (activity?.gear ?? ""))
                    Text("Distance: " + (activity?.distanceInKilometres ?? ""))
                    Text("Duration: " + (activity?.elapsedTimeString ?? ""))
                }
                Spacer()
            }
        }
        .padding(8)
        .background(Color("DisclosureBackground"))
        .frame(maxWidth: 250, alignment: .leading)
        .cornerRadius(8)
        .padding(10)
    }
}


#if DEBUG
struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailView(activity: .constant(.dummy1))
            .frame(width: 600, height: 600)
            .environmentObject(AppCoordinator(db: .dummy))
    }
}
#endif
