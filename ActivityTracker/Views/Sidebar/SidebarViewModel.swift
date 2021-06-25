//
//  SidebarViewModel.swift
//  ActivityTracker
//
//  Created by gary on 25/06/2021.
//

import Combine

final class SidebarViewModel: ObservableObject {
    @Published var selectionActivity: Int? = 1
    @Published var selectionDuration: Int? = 1
}
