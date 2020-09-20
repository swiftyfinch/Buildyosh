//
//  XcodeLogAsyncParser.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 28.06.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

final class XcodeLogAsyncParser: ObservableObject {

    private let store: Store<State, Action>

    init(store: Store<State, Action>) {
        self.store = store
    }

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
            self?.store.send(.beginLoading)
        }
        let projects = XcodeLogParser().parse(logs: logs) {
            current += 1
            DispatchQueue.asyncOnMain { [weak self] in
                self?.store.send(.changeProgress(Double(current) / Double(max)))
            }
        }

        DispatchQueue.asyncOnMain { [weak self] in
            self?.store.send(.endLoading)
            completion(projects)
        }
    }
}
