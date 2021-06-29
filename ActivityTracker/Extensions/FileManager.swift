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
}
