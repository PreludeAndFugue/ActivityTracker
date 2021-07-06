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
    class Coordinator: NSObject, MKMapViewDelegate {
        var activityId: String? = nil
        var coordinates: [CLLocationCoordinate2D]? = nil


        func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
            let r = MKPolylineRenderer(overlay: overlay)
            r.strokeColor = .red
            r.lineWidth = 3
            return r
        }


        func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
            guard let annotation = annotation as? ActivityAnnotation else { return nil }
            let view = MKPinAnnotationView(annotation: annotation, reuseIdentifier: "hello")
            switch annotation.type {
            case .start:
                view.pinTintColor = .green
            case .end:
                view.pinTintColor = .red
            }
            return view
        }


        func save(coordinates: [CLLocationCoordinate2D], for activity: Activity) {
            self.coordinates = coordinates
            self.activityId = activity.id
        }
    }


    @EnvironmentObject var appCoordinator: AppCoordinator
    @EnvironmentObject var gpxReader: GpxReader
    @EnvironmentObject var fitReader: FitReader

    var activity: Activity?


    init(activity: Activity?) {
        self.activity = activity
    }

    
    func makeNSView(context: Context) -> MKMapView {
        let map = MKMapView()
        map.delegate = context.coordinator
        map.register(MKPinAnnotationView.self, forAnnotationViewWithReuseIdentifier: "hello")
        return map
    }


    func updateNSView(_ nsView: MKMapView, context: Context) {
        guard let activity = activity else { return }
        let coordinates = makeCoordinates(for: activity, context: context)
        nsView.removeOverlays(nsView.overlays)
        nsView.removeAnnotations(nsView.annotations)
        addAnnotations(to: nsView, coordinates: coordinates)
        DispatchQueue.main.async {
            nsView.setRegion(self.makeRegion(coordinates), animated: true)
            nsView.addOverlay(self.makeOverlay(coordinates))
        }
        appCoordinator.zoomResetAction = {
            let coordinates = self.makeCoordinates(for: self.activity, context: context)
            nsView.setRegion(self.makeRegion(coordinates), animated: true)
        }
    }


    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
}


// MARK: - Private

private extension ActivityDetailMap {
    func makeCoordinates(for activity: Activity?, context: Context) -> [CLLocationCoordinate2D] {
        if activity?.id == context.coordinator.activityId, let coordinates = context.coordinator.coordinates {
            return coordinates
        }
        guard let activity = activity else {
            return []
        }
        switch activity.fileType {
        case .fit:
            let coordinates = fitReader.coordinates(for: activity)
            context.coordinator.save(coordinates: coordinates, for: activity)
            return coordinates
        case .gpx:
            let coordinates = gpxReader.coordinates(for: activity)
            context.coordinator.save(coordinates: coordinates, for: activity)
            return coordinates
        case .gz:
            return []
        case .tcx:
            return []
        case .none:
            return []
        }
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
