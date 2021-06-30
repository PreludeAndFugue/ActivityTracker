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
            ActivityListItemView(activity: activity, selection: $model.selectedActivity)
        }
        .onAppear {
            model.setSelection()
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
        .alert(isPresented: $model.isError, content: alert)
        .frame(idealWidth: 300)
    }
}


// MARK: - Private

private extension ActivityListView {
    func alert() -> Alert {
        Alert(
            title: Text("Error"),
            message: Text(model.errorMessage),
            dismissButton: .default(Text("OK"))
        )
    }


    var allowedContentTypes: [UTType] {
        [
            UTType(filenameExtension: "fit") ?? .xml,
            UTType(filenameExtension: "gpx") ?? .xml
        ]
    }
}


#if DEBUG
struct ActivityListView_Previews: PreviewProvider {
    private static let model = ActivityListViewModel(db: .dummy)
    static var previews: some View {
        ActivityListView(model: model)
    }
}
#endif
