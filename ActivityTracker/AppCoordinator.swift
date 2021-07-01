//
//  AppCoordinator.swift
//  ActivityTracker
//
//  Created by gary on 01/07/2021.
//

import Combine
import UniformTypeIdentifiers

final class AppCoordinator: ObservableObject {
    typealias ZoomResetAction = () -> Void

    private var error: Error?

    @Published var isError = false
    @Published var isImporting = false

    let db: Database

    var zoomResetAction: ZoomResetAction?

    var errorMessage: String {
        error?.localizedDescription ?? "Unknown error"
    }

    var firstActivity: Activity? {
        db.currentActivities.first
    }

    let allowedContentTypes: [UTType] = [
        UTType(filenameExtension: "fit") ?? .xml,
        UTType(filenameExtension: "gpx") ?? .xml
    ]


    init(db: Database) {
        self.db = db
    }


    func startImport() {
        isImporting.toggle()
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
}


// MARK: - Private

private extension AppCoordinator {
    func open(url: URL) {
        switch url.pathExtension {
        case "gpx":
            openGpx(url: url)
        case "fit":
            openFit(url: url)
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

    }
}
