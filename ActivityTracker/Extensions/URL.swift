//
//  URL.swift
//  ActivityTracker
//
//  Created by gary on 03/07/2021.
//

import Foundation

extension URL {
    enum FileType: String, Codable {
        case gpx
        case fit
        case gz
        case tcx
    }


    var fileType: FileType? {
        guard let ft = absoluteString.split(separator: ".").last else {
            return nil
        }
        return FileType(rawValue: String(ft))
    }


    func removeGz() -> URL {
        guard fileType == .gz else {
            return self
        }
        let parts = absoluteString.split(separator: ".")
        return URL(string: parts.dropLast().joined(separator: "."))!
    }
}
