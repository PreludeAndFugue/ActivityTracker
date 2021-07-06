//
//  ActivityDetailMap.swift
//  ActivityTracker
//
//  Created by gary on 25/06/2021.
//

import CoreLocation
import MapKit
import SwiftUI

struct ActivityDetailMap: NSViewRepresentable {
    class Coordinator: NSObject {
        var activity: Activity? = nil
        var coordinates: [CLLocationCoordinate2D]? = nil


        func update(activity: Activity) -> [CLLocationCoordinate2D]? {
            if activity == self.activity { return nil }
            self.activity = activity
            self.coordinates = makeCoordinates(for: activity)
            return coordinates
        }


        private func makeCoordinates(for activity: Activity) -> [CLLocationCoordinate2D] {
            switch activity.fileType {
            case .fit:
                return FitReader.shared.coordinates(for: activity)
            case .gpx:
                return GpxReader.shared.coordinates(for: activity)
            case .gz:
                return []
            case .tcx:
                return []
            case .none:
                return []
            }
        }
    }


    @EnvironmentObject var appCoordinator: AppCoordinator
    @EnvironmentObject var gpxReader: GpxReader
    @EnvironmentObject var fitReader: FitReader

    var activity: Activity?
    var mapType = MKMapType.standard


    init(activity: Activity?, mapType: MKMapType) {
        self.mapType = mapType
        self.activity = activity
    }

    
    func makeNSView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.mapType = mapType
        map.delegate = context.coordinator
        map.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: "hello")
        return map
    }


    func updateNSView(_ nsView: MKMapView, context: Context) {
        guard let activity = activity else { return }
        nsView.mapType = mapType
        guard let coordinates = context.coordinator.update(activity: activity) else {
            return
        }
        nsView.removeOverlays(nsView.overlays)
        nsView.removeAnnotations(nsView.annotations)
        addAnnotations(to: nsView, coordinates: coordinates)
        let region = makeRegion(coordinates)
        DispatchQueue.main.async {
            nsView.setRegion(region, animated: true)
            nsView.addOverlay(self.makeOverlay(coordinates))
        }
        appCoordinator.zoomResetAction = {
            nsView.setRegion(region, animated: true)
        }
    }


    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
}


// MARK: - MKMapViewDelegate

extension ActivityDetailMap.Coordinator: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let r = MKPolylineRenderer(overlay: overlay)
        r.strokeColor = .red
        r.lineWidth = 3
        return r
    }


    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        guard
            let annotation = annotation as? ActivityAnnotation,
            let view = mapView.dequeueReusableAnnotationView(withIdentifier: "hello") as? MKPinAnnotationView
        else {
            return nil
        }
        switch annotation.type {
        case .start:
            view.pinTintColor = .green
        case .end:
            view.pinTintColor = .red
        }
        return view
    }
}


// MARK: - Private

private extension ActivityDetailMap {
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


    func addAnnotations(to map: MKMapView, coordinates: [CLLocationCoordinate2D]) {
        if let first = coordinates.first {
            let start = ActivityAnnotation(coordinate: first, type: .start)
            map.addAnnotation(start)
        }
        if let last = coordinates.last {
            let end = ActivityAnnotation(coordinate: last, type: .end)
            map.addAnnotation(end)
        }
    }


    func makeOverlay(_ coordinates: [CLLocationCoordinate2D]) -> MKPolyline {
        let p = MKPolyline(coordinates: coordinates, count: coordinates.count)
        return p
    }
}
