//
//  BadgeView.swift
//  ActivityTracker
//
//  Created by gary on 09/07/2021.
//

import SwiftUI

struct BadgeView: View {
    let number: Int

    var body: some View {
        Text("\(number)")
            .font(.caption2)
            .padding([.leading, .trailing], 3)
            .background(Color.gray.opacity(0.5))
            .clipShape(Capsule())
    }
}
