//
//  ActivityListViewModel.swift
//  ActivityTracker
//
//  Created by gary on 27/06/2021.
//

import Combine
import Foundation

final class ActivityListViewModel: ObservableObject {
    let db: Database

    @Published var selectedActivity: Activity? = nil
    @Published var isImporting = false
    @Published var isError = false

    var errorMessage: String {
        error?.localizedDescription ?? "Unknown error"
    }

    private var error: Error?


    init(db: Database) {
        self.db = db
    }


    func startImport() {
        isImporting.toggle()
    }


    func completion(result: Result<URL, Error>) {
        switch result {
        case .success(let url):
            open(url: url)
        case .failure(let error):
            print(error)
        }
    }


    func setSelection() {
        selectedActivity = db.currentActivities.first
    }
}


// MARK: - Private

private extension ActivityListViewModel {
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
