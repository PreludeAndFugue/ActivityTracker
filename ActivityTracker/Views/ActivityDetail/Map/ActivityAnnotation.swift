//
//  ActivityAnnotation.swift
//  ActivityTracker
//
//  Created by gary on 06/07/2021.
//

import MapKit

final class ActivityAnnotation: NSObject, MKAnnotation {
    enum AnnotationType {
        case start
        case end
    }

    let coordinate: CLLocationCoordinate2D
    let type: AnnotationType


    init(coordinate: CLLocationCoordinate2D, type: AnnotationType) {
        self.coordinate = coordinate
        self.type = type
    }
}
