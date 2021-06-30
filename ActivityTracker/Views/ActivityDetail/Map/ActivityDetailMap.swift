//
//  ActivityDetailMap.swift
//  ActivityTracker
//
//  Created by gary on 25/06/2021.
//

import CoreLocation
import MapKit
import SwiftUI

final class ActivityDetailMap: NSObject, NSViewRepresentable {
    class Coordinator: NSObject, MKMapViewDelegate {
        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            if mapView.overlays.count > 1, let o = mapView.overlays.first {
                mapView.removeOverlay(o)
            }
            let r = MKPolylineRenderer(overlay: overlay)
            r.strokeColor = .red
            r.lineWidth = 3
            return r
        }
    }


    var activity: Activity?
    private let gpxReader: GpxReader


    init(activity: Activity?, gpxReader: GpxReader) {
        self.activity = activity
        self.gpxReader = gpxReader
    }

    
    func makeNSView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        return map
    }


    func updateNSView(_ nsView: MKMapView, context: Context) {
        guard let activity = activity else { return }
        let coordinates = makeCoordinates(for: activity)
        DispatchQueue.main.async {
            nsView.setRegion(self.makeRegion(coordinates), animated: true)
            nsView.addOverlay(self.makeOverlay(coordinates))
        }
    }


    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
}


// MARK: - Private

private extension ActivityDetailMap {
    func makeCoordinates(for activity: Activity?) -> [CLLocationCoordinate2D] {
        guard let activity = activity else {
            return []
        }
        return gpxReader.coordinates(for: activity)
    }


    func makeRegion(_ coordinates: [CLLocationCoordinate2D]) -> MKCoordinateRegion {
        let minLat = coordinates.map({ $0.latitude }).min() ?? 50
        let maxLat = coordinates.map({ $0.latitude }).max() ?? 51
        let minLng = coordinates.map({ $0.longitude}).min() ?? 0
        let maxLng = coordinates.map({ $0.longitude}).max() ?? 1

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
