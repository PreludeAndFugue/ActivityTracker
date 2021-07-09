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
        let interval = Calendar.current.weekInterval(containing: Date())
        print(interval)
    }


    func testMonthContainingDate() {
        let interval = Calendar.current.monthInterval(containing: Date())
        print(interval)
    }


    func testYearContainingDate() {
        let interval = Calendar.current.yearInterval(containing: Date())
        print(interval)
    }


    func testDatesInWeekInterval() {
        let interval = Calendar.current.weekInterval(containing: Date())
        let dates = Calendar.current.dates(in: interval)
        XCTAssertEqual(dates.count, 7)
    }


    func testDatesInMonthInterval() {
        let components = DateComponents(year: 2021, month: 7, day: 5)
        let date = Calendar.current.date(from: components)!
        let interval = Calendar.current.monthInterval(containing: date)
        let dates = Calendar.current.dates(in: interval)
        XCTAssertEqual(dates.count, 31)
    }
}
