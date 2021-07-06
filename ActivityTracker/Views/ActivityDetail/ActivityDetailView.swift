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

    @State var mapType = MKMapType.standard

    var body: some View {
        GeometryReader { proxy in
            ActivityDetailMap(activity: appCoordinator.currentActivity, mapType: mapType)
                .overlay(disclosure, alignment: .topLeading)
                .overlay(ElevationView(width: proxy.size.width), alignment: .bottomLeading)
                .overlay(mapTypeButton, alignment: .topTrailing)
        }
    }
}


// MARK: - Private

private extension ActivityDetailView {
    var disclosure: some View {
        ActivityDetailDisclosure(activity: appCoordinator.currentActivity)
    }


    var mapTypeButton: some View {
        HStack {
            Button(action: toggleMapType) {
                Image(systemName: "map")
            }
        }
        .padding(10)
    }


    func toggleMapType() {
        if mapType == .standard {
            mapType = .satellite
        } else {
            mapType = .standard
        }
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
