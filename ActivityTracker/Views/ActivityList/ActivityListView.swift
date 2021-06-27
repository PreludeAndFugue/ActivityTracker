//
//  ActivityListView.swift
//  ActivityTracker
//
//  Created by gary on 23/06/2021.
//

import SwiftUI
import UniformTypeIdentifiers

import CoreGPX


struct ActivityListView: View {
    @EnvironmentObject var db: Database

    @State var isImporting = false


    var body: some View {
        List(db.currentActivities) { activity in
            ActivityListItemView(activity: activity)
        }
        .toolbar {
            Button(action: {}) {
                Image(systemName: "square.and.arrow.up")
            }
            Button(action: importFile) {
                Image(systemName: "square.and.arrow.down")
            }
        }
        .fileImporter(
            isPresented: $isImporting,
            allowedContentTypes: allowedContentTypes,
            onCompletion: { result in
                print(result)
                switch result {
                case .success(let url):
                    open(url: url)
                case .failure(let error):
                    print("error importing file", error)
                }
            }
        )
        .frame(minWidth: 250)
    }
}


// MARK: - Private

private extension ActivityListView {
    func importFile() {
        isImporting.toggle()
    }


    var allowedContentTypes: [UTType] {
        [
            UTType(filenameExtension: "fit") ?? .xml,
            UTType(filenameExtension: "gpx") ?? .xml
        ]
    }


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
            print(activity)
        } catch let error {
            print(error)
        }
    }


    func openFit(url: URL) {

    }
}


#if DEBUG
struct ActivityListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListView()
    }
}
#endif
