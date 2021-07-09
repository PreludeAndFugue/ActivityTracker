//
//  Calendar.swift
//  ActivityTracker
//
//  Created by gary on 09/07/2021.
//

import Foundation

extension Calendar {
    func week(containing date: Date) -> DateInterval {
        dateInterval(of: .weekOfYear, for: date)!
    }
}
