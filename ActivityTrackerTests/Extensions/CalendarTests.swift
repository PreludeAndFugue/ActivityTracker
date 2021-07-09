//
//  CalendarTests.swift
//  ActivityTrackerTests
//
//  Created by gary on 09/07/2021.
//

import XCTest
@testable import ActivityTracker

class CalendarTests: XCTestCase {
    func testWeekContainingDate() throws {
        let interval = Calendar.current.week(containing: Date())
        print(interval)
    }
}
