//
//  DistanceTests.swift
//  SportsDbTest02Tests
//
//  Created by gary on 06/04/2019.
//  Copyright © 2019 Gary Kerr. All rights reserved.
//

import XCTest
@testable import ActivityTracker

class DistanceTests: XCTestCase {
    func test1() {
        let lyonLat = 45.7597
        let lyonLng = 4.8422
        let parisLat = 48.8567
        let parisLng = 2.3508

        let d = distanceDegrees(lat1: lyonLat, lng1: lyonLng, lat2: parisLat, lng2: parisLng)
        XCTAssertEqual(d, 392_217.2595594006, accuracy: 1.0)
    }


    func test2() {
        let lat1 = 38.898556
        let lng1 = -77.037852
        let lat2 = 38.897147
        let lng2 = -77.043934

        let d = distanceDegrees(lat1: lat1, lng1: lng1, lat2: lat2, lng2: lng2)
        XCTAssertEqual(d, 549, accuracy: 0.2)
    }
}
