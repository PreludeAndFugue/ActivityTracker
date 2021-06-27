//
//  ActivityDetailMap.swift
//  ActivityTracker
//
//  Created by gary on 25/06/2021.
//

import MapKit
import SwiftUI

final class ActivityDetailMap: NSObject, NSViewRepresentable {
    private let activity: Activity
    private let gpxReader: GpxReader


    init(activity: Activity, gpxReader: GpxReader) {
        self.activity = activity
        self.gpxReader = gpxReader
    }

    
    func makeNSView(context: Context) -> some NSView {
        let map = MKMapView()
        let coordinates = gpxReader.coordinates(for: activity)
        map.region = makeRegion(coordinates)
        map.addOverlay(makeOverlay(coordinates))
        map.delegate = self
        return map
    }


    func updateNSView(_ nsView: NSViewType, context: Context) {

    }
}


extension ActivityDetailMap: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let r = MKPolylineRenderer(overlay: overlay)
        r.strokeColor = .red
        return r
    }
}


// MARK: - Private

private extension ActivityDetailMap {
    func makeRegion(_ coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        let minLat = coordinates.map({ $0.latitude }).min() ?? 50
        let maxLat = coordinates.map({ $0.latitude }).max() ?? 51
        let minLng = coordinates.map({ $0.longitude}).min() ?? 0
        let maxLng = coordinates.map({ $0.longitude}).max() ?? 0.4

        let dLat = maxLat - minLat
        let dLng = maxLng - minLng

        let midLat = minLat + dLat / 2
        let midLng = minLng + dLng / 2

        let latMetres = distanceDegrees(lat1: minLat, lng1: midLng, lat2: maxLat, lng2: midLng)
        let lngMetres = distanceDegrees(lat1: midLat, lng1: minLng, lat2: midLat, lng2: maxLng)

        let centre = CLLocationCoordinate2D(latitude: midLat, longitude: midLng)

        let region = MKCoordinateRegion(
            center: centre,
            latitudinalMeters: 1.1 * latMetres,
            longitudinalMeters: 1.1 * lngMetres
        )
        return region
    }


    func makeOverlay(_ coordinates: [CLLocationCoordinate2D]) -> MKPolyline {
        let p = MKPolyline(coordinates: coordinates, count: coordinates.count)
        return p
    }
}
