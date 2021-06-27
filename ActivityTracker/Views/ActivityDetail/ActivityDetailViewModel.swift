//
//  ActivityDetailViewModel.swift
//  ActivityTracker
//
//  Created by gary on 27/06/2021.
//

import Combine
import SwiftUI

final class ActivityDetailViewModel: ObservableObject {
    let activity: Activity

    @Published var isShowingDetails = true
    @Published var chevronAngle: Angle = .zero
    @Published var disclosureText = "Activity information"


    init(activity: Activity) {
        self.activity = activity
    }


    func toggleDetails() {
        SwiftUI.withAnimation {
            isShowingDetails.toggle()
            chevronAngle = isShowingDetails ? .zero : Angle(degrees: -90)
//            disclosureText = isShowingDetails ? "Activity information" : ""
        }
    }
}
