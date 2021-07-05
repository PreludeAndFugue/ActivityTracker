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
                .overlay(disclosure, alignment: .topLeading)
                .overlay(ElevationView(width: proxy.size.width), alignment: .bottomLeading)
        }
    }
}


// MARK: - Private

private extension ActivityDetailView {
    var disclosure: some View {
        ActivityDetailDisclosure(activity: appCoordinator.currentActivity)
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
