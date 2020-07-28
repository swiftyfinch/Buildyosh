//
//  XcodeLogFinder.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 11.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct XcodeLogFinder {

    func findLogs(derivedDataURL: URL) -> [String: [URL]] {
        guard let content = try? FileManager.default.contentsOfDirectory(atPath: derivedDataURL.path) else {
            log(.error, "Can't find derivedData directory at \(derivedDataURL.path)")
            return [:]
        }

        let projectsFileNames = content
            .filter { !$0.hasPrefix(.dot) && !$0.hasSuffix(.noindex) }

        return projectsFileNames.reduce(into: [:]) { map, name in
            let logsURL = derivedDataURL.appendingPathComponent(name + .logsPath)
            guard let content = try? FileManager.default.contentsOfDirectory(atPath: logsURL.path) else {
                log(.error, "Can't find build file log at \(logsURL.path)")
                return
            }

            let files = content.filter { $0.hasSuffix(.xcactivitylog) }
            map[name] = files.map { logsURL.appendingPathComponent($0) }
        }
    }
}

private extension String {
    static let dot = "."
    static let noindex = ".noindex"
    static let logsPath = "/Logs/Build"
    static let xcactivitylog = ".xcactivitylog"
}
