//
//  Calendar.swift
//  ActivityTracker
//
//  Created by gary on 09/07/2021.
//

import Foundation

extension Calendar {
    func weekInterval(containing date: Date) -> DateInterval {
        dateInterval(of: .weekOfYear, for: date)!
    }


    func monthInterval(containing date: Date) -> DateInterval {
        dateInterval(of: .month, for: date)!
    }


    func yearInterval(containing date: Date) -> DateInterval {
        dateInterval(of: .year, for: date)!
    }


    func dates(in interval: DateInterval) -> [Date] {
        var ds: [Date] = []
        var i = 0
        while true {
            let next = date(byAdding: .day, value: i, to: interval.start)!
            if next < interval.end {
                ds.append(next)
                i += 1
            } else {
                break
            }
        }
        return ds
    }
}
