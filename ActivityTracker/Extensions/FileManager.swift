//
//  FileManager.swift
//  ActivityTracker
//
//  Created by gary on 29/06/2021.
//

import Foundation

extension FileManager {
    var documentDirectory: URL? {
        urls(for: .documentDirectory, in: .userDomainMask).first
    }


    func copyFileToSandbox(url: URL) throws -> URL {
        guard var destination = documentDirectory else {
            throw ReaderError.noAccessToDocumentFolder
        }
        destination.appendPathComponent(url.lastPathComponent)
        do {
            try copyItem(at: url, to: destination)
        }
        return destination
    }
}
