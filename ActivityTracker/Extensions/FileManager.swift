//
//  FileManager.swift
//  ActivityTracker
//
//  Created by gary on 29/06/2021.
//

import Foundation

import Gzip

extension FileManager {
    var documentDirectory: URL? {
        urls(for: .documentDirectory, in: .userDomainMask).first
    }


    func url(for activity: Activity) -> URL {
        let u = URL(fileURLWithPath: activity.fileName)
        let f = documentDirectory!
        return f.appendingPathComponent(u.lastPathComponent)
    }


    func copyFileToSandbox(url: URL) throws -> URL {
        guard var destination = documentDirectory else {
            throw ReaderError.noAccessToDocumentFolder
        }
        if url.fileType == .gz {
            let newUrl = url.removeGz()
            destination.appendPathComponent(newUrl.lastPathComponent)
            let data = try Data(contentsOf: url)
            let uncompressed = try data.gunzipped()
            let _ = createFile(
                atPath: destination.path,
                contents: uncompressed,
                attributes: nil
            )
            return destination
        } else {
            destination.appendPathComponent(url.lastPathComponent)
            do {
                try copyItem(at: url, to: destination)
            }
            return destination
        }
    }
}
