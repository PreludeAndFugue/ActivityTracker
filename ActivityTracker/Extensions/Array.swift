//
//  Array.swift
//  ActivityTracker
//
//  Created by gary on 05/07/2021.
//

import Foundation


extension Array {
    func limitNumberOfElements() -> Self {
        let filter: Int
        switch count {
        case 8_000...:
            filter = 5
        case 6_000...7_999:
            filter = 4
        case 4_000...5_999:
            filter = 3
        case 2_000...3_999:
            filter = 2
        default:
            filter = 1
        }
        if filter == 1 {
            return self
        } else {
            return enumerated().filter({ $0.offset % filter == 0 }).map({ $0.element })
        }
    }
}
