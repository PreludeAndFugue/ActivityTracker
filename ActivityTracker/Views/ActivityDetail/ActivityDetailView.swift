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

    var body: some View {
        GeometryReader { proxy in
            ActivityDetailMap(activity: appCoordinator.currentActivity)
                .overlay(overlay, alignment: .topLeading)
                .overlay(ElevationView(width: proxy.size.width), alignment: .bottomLeading)
        }
    }
}


// MARK: - Private

private extension ActivityDetailView {
    var overlay: some View {

        DisclosureGroup("Activity information") {
            HStack {
                VStack(alignment: .leading) {
                    Text(title)
                    Text(dateString)
                    Text("Type: \(typeString)")
                    Text("Gear: \(gearString)")
                    Text("Distance: \(distanceString)")
                    Text("Duration: \(durationString)")
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


    var title: String {
        appCoordinator.currentActivity?.title ?? ""
    }


    var dateString: String {
        appCoordinator.currentActivity?.dateString ?? ""
    }


    var typeString: String {
        guard let type = appCoordinator.currentActivity?.type else {
            return ""
        }
        return type.title
    }


    var gearString: String {
        guard let gear = appCoordinator.currentActivity?.gear else {
            return ""
        }
        return gear.description
    }


    var distanceString: String {
        appCoordinator.currentActivity?.distanceInKilometres ?? ""
    }


    var durationString: String {
        appCoordinator.currentActivity?.elapsedTimeString ?? ""
    }
}


#if DEBUG
struct ActivityDetailView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityDetailView()
            .frame(width: 600, height: 600)
            .environmentObject(AppCoordinator(db: .dummy))
    }
}
#endif
