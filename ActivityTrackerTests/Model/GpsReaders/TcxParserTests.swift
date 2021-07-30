//
//  TcxParserTests.swift
//  ActivityTrackerTests
//
//  Created by gary on 30/07/2021.
//

import XCTest
@testable import ActivityTracker

class TcxParserTests: XCTestCase {
    private var bundle: Bundle!


    override func setUp() {
        bundle = Bundle(for: type(of: self))
    }


    func testExample() throws {
        guard let url = bundle.url(forResource: "1154180442", withExtension: "tcx") else {
            XCTFail()
            return
        }
        let parser = TcxParser(url: url)
        let points = parser.parse()
        print(points)
    }
}
