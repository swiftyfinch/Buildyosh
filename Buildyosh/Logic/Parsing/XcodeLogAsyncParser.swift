//
//  XcodeLogAsyncParser.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 28.06.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

final class XcodeLogAsyncParser: ObservableObject {

    @Published private(set) var isLoaded = false
    @Published private(set) var progress: Double = 0.0

    func asyncReadProjectsLogs(logs: [String: [URL]],
                               completion: @escaping ([ProjectLog]) -> Void) {
        DispatchQueue.global().async { [weak self] in
            self?.readProjectsLogs(logs: logs, completion: completion)
        }
    }

    func readProjectsLogs(logs: [String: [URL]],
                          completion: @escaping ([ProjectLog]) -> Void) {
        var current = 0
        let max = logs.values.reduce(0) { $0 + $1.count }

        DispatchQueue.asyncOnMain { [weak self] in
            self?.isLoaded = false
        }
        let projects = XcodeLogParser().parse(logs: logs) {
            current += 1
            DispatchQueue.asyncOnMain { [weak self] in
                self?.progress = Double(current) / Double(max)
            }
        }

        DispatchQueue.asyncOnMain { [weak self] in
            self?.isLoaded = true
            completion(projects)
        }
    }
}
