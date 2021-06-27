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
    @StateObject var model: ActivityListViewModel


    var body: some View {
        List(model.db.currentActivities) { activity in
            ActivityListItemView(activity: activity)
        }
        .toolbar {
            Button(action: model.startImport) {
                Image(systemName: "square.and.arrow.down")
            }
        }
        .fileImporter(
            isPresented: $model.isImporting,
            allowedContentTypes: allowedContentTypes,
            onCompletion: model.completion(result:)
        )
        .frame(minWidth: 250)
    }
}


// MARK: - Private

private extension ActivityListView {
    var allowedContentTypes: [UTType] {
        [
            UTType(filenameExtension: "fit") ?? .xml,
            UTType(filenameExtension: "gpx") ?? .xml
        ]
    }
}


#if DEBUG
struct ActivityListView_Previews: PreviewProvider {
    static var previews: some View {
        ActivityListView(model: ActivityListViewModel(db: Database()))
    }
}
#endif
