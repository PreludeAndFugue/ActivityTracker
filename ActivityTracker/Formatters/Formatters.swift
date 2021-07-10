//
//  Formatters.swift
//  ActivityTracker
//
//  Created by gary on 10/07/2021.
//

import Foundation

var dateFormatter: DateFormatter = {
    var df = DateFormatter()
    df.dateStyle = .medium
    df.timeStyle = .short
    return df
}()


var elapsedTimeFormatter: DateComponentsFormatter = {
    var df = DateComponentsFormatter()
    df.allowedUnits = [.hour, .minute, .second]
    df.maximumUnitCount = 2
    df.unitsStyle = .abbreviated
    return df
}()


var distanceFormatter: MeasurementFormatter = {
    var nf = NumberFormatter()
    nf.numberStyle = .decimal
    nf.maximumFractionDigits = 2
    var mf = MeasurementFormatter()
    mf.unitOptions = .providedUnit
    mf.unitStyle = .short
    mf.numberFormatter = nf
    return mf
}()


var percentageFormatter: NumberFormatter = {
    var nf = NumberFormatter()
    nf.numberStyle = .percent
    nf.maximumFractionDigits = 1
    return nf
}()
