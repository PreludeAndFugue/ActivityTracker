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
    @Published var sidebarSelection: SidebarViewModel.Selection = .allActivities
    @Published var isError = false
    @Published var isImporting = false

    private let db: Database

    var zoomResetAction: ZoomResetAction?

    var errorMessage: String {
        error?.localizedDescription ?? "Unknown error"
    }

    let allowedContentTypes: [UTType] = [
        UTType(filenameExtension: "fit") ?? .xml,
        UTType(filenameExtension: "gpx") ?? .xml,
        UTType.commaSeparatedText
    ]


    init(db: Database) {
        self.db = db
        currentActivities = db.get(for: nil)
        currentActivity = currentActivities.first
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


    func sidebar(selection: SidebarViewModel.Selection) {
        switch selection {
        case .allActivities:
            currentActivities = db.get(for: nil)
            currentActivity = currentActivities.first
        case .bike:
            currentActivities = db.get(for: .bike)
            currentActivity = currentActivities.first
        case .run:
            currentActivities = db.get(for: .run)
            currentActivity = currentActivities.first
        case .activitiesWeek:
            break
        case .activitiesMonth:
            break
        case .statsWeek:
            break
        case .statsMonth:
            break
        }
        self.sidebarSelection = selection
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
}
