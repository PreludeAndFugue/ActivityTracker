//
//  SidebarViewModel.swift
//  ActivityTracker
//
//  Created by gary on 25/06/2021.
//

import Combine

final class SidebarViewModel: ObservableObject {
    enum SelectionActivity {
        case all
        case bike
        case run
    }

    @Published var selectionActivity: SelectionActivity? = .all
    @Published var selectionDuration: Int? = 1


    private var cancellables: Set<AnyCancellable> = []


    func changeSelection(value: SelectionActivity?) {
        guard let value = value else { return }
        print(value)
    }


    func activityType(selection: SelectionActivity?) -> Activity.ActivityType? {
        selection?.activityType
    }
}


// MARK: - Private

private extension SidebarViewModel.SelectionActivity {
    var activityType: Activity.ActivityType? {
        switch self {
        case .all: return nil
        case .bike: return .bike
        case .run: return .run
        }
    }
}
