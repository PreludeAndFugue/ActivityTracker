//
//  ActivityDetailMap.swift
//  ActivityTracker
//
//  Created by gary on 25/06/2021.
//

import MapKit
import SwiftUI

final class ActivityDetailMap: NSViewRepresentable {
    private let activity: Activity


    init(activity: Activity) {
        self.activity = activity
    }

    
    func makeNSView(context: Context) -> some NSView {
        let map = MKMapView()
        map.region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 51.507222, longitude: -0.1275),
            span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5)
        )
        return map
    }


    func updateNSView(_ nsView: NSViewType, context: Context) {

    }
}
