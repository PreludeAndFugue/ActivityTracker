//
//  ActivityDetailViewModel.swift
//  ActivityTracker
//
//  Created by gary on 27/06/2021.
//

import Combine

final class ActivityDetailViewModel: ObservableObject {
    let activity: Activity


    init(activity: Activity) {
        self.activity = activity
    }
}
