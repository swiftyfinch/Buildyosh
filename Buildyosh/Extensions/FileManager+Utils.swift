//
//  FileManager+Utils.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 17.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

extension FileManager {
    static func createDirectoryIfNeeded(at url: URL) throws {
        guard url.isDirectoryNotExists else { return }
        try Self.default.createDirectory(at: url, withIntermediateDirectories: false)
    }
}

private extension URL {
    var isDirectoryNotExists: Bool {
        var isDirectory: ObjCBool = false
        let isExists = FileManager.default.fileExists(atPath: path, isDirectory: &isDirectory)
        return !(isExists && isDirectory.boolValue)
    }
}
