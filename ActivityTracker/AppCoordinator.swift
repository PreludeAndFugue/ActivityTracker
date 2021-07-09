//
//  AppCoordinator.swift
//  ActivityTracker
//
//  Created by gary on 01/07/2021.
//

import Combine
import Cocoa
import UniformTypeIdentifiers

final class AppCoordinator: ObservableObject {
    typealias ZoomResetAction = () -> Void

    private var error: Error?

    @Published var currentActivities: [Activity] = []
    @Published var currentActivity: Activity? = nil
    @Published var activityCount: Database.ActivityCount = .zero
    @Published var sidebarSelection: SidebarView.Selection? = .allActivities
    @Published var isError = false
    @Published var isImporting = false

    private let db: Database

    var zoomResetAction: ZoomResetAction?

    var errorMessage: String {
        error?.localizedDescription ?? "Unknown error"
    }

    var isShowingActivities: Bool {
        sidebarSelection?.isShowingActivities ?? true
    }

    let allowedContentTypes: [UTType] = [
        UTType(filenameExtension: "fit") ?? .xml,
        UTType(filenameExtension: "gpx") ?? .xml,
        UTType.commaSeparatedText
    ]


    init(db: Database) {
        self.db = db
        refreshActivities(for: nil)
    }


    func startImport() {
        isImporting.toggle()
    }


    func startStravaImport() {
        let panel = NSOpenPanel()
        panel.canChooseDirectories = true
        if panel.runModal() == .OK {
            bulkStravaImport(url: panel.url!)
        }
    }


    func importCompletion(result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            open(url: url)
        case .failure(let error):
            self.error = error
            isError = true
        }
    }


    func sidebar() {
        switch sidebarSelection {
        case .allActivities:
            refreshActivities(for: nil)
        case .bike:
            refreshActivities(for: .bike)
        case .run:
            refreshActivities(for: .run)
        case .walk:
            refreshActivities(for: .walk)
        case .activitiesWeek:
            break
        case .activitiesMonth:
            break
        case .statsWeek:
            break
        case .statsMonth:
            break
        case .none:
            break
        }
    }


    var activityElevationData: [DistanceElevation] {
        guard let activity = currentActivity else { return [] }
        switch activity.fileType {
        case .fit:
            return FitReader.shared.elevation(for: activity)
        case .gpx:
            return GpxReader.shared.elevation(for: activity)
        case .gz:
            return []
        case .tcx:
            return []
        case .none:
            return []
        }
    }
}


// MARK: - Private

private extension AppCoordinator {
    func open(url: URL) {
        switch url.pathExtension {
        case "gpx":
            openGpx(url: url)
        case "fit":
            openFit(url: url)
        case "csv":
            bulkStravaImport(url: url)
        default:
            print("unknown extension", url.pathExtension)
        }
    }


    func openGpx(url: URL) {
        do {
            let activity = try GpxReader.shared.createActivity(with: url)
            db.create(activity)
        } catch let error {
            self.error = error
            isError = true
        }
    }


    func openFit(url: URL) {
        do {
            let activity = try FitReader.shared.createActivity(with: url)
            db.create(activity)
        } catch let error {
            self.error = error
            isError = true
        }
    }


    func bulkStravaImport(url: URL) {
        do {
            let activities = try StravaReader.shared.createActivities(with: url)
            db.create(activities)
        } catch let error {
            self.error = error
            isError = true
        }
    }


    func refreshActivities(for activityType: Activity.ActivityType?) {
        currentActivities = db.get(for: activityType)
        currentActivity = currentActivities.first
        activityCount = db.activityCount()
    }
}
