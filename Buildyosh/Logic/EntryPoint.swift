//
//  EntryPoint.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 19.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

final class EntryPoint: ObservableObject {

    private let derivedDataURL = URL.derivedData
    private let storage = Storage()

    private let store: Store<MainState, Action>
    private let xcodeLogManager: XcodeLogAsyncParser

    private var running = false
    private let timerInterval = 60.0 / 4

    @UserStorage("importProjectsDate")
    private var importProjectsDate: Date?

    init(store: Store<MainState, Action>,
         xcodeLogManager: XcodeLogAsyncParser) {
        self.store = store
        self.xcodeLogManager = xcodeLogManager
    }

    func run() {
        guard !running else { return }

        running = true
        storage.load { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.findProjects { [weak self] projectLogs in
                    guard let self = self else { return }

                    let today = Date()
                    self.storage.saveProjects(projectLogs, relativeDate: today) { [weak self] in
                        guard let self = self else { return }

                        if let periods = self.storage.loadPeriods(relativeDate: today) {
                            self.store.send(.updatePeriods(periods: periods))
                            log(.info, "Scan new projects. Found: \(periods)")
                        } else {
                            log(.info, "Scan new projects.")
                        }
                        self.running = false
                    }
                }

            case .failure(let error):
                self.running = false
                log(error)
            }
        }
    }

    func runRepeatedly() {
        run()
        let timer = Timer.scheduledTimer(withTimeInterval: timerInterval,
                                         repeats: true) { [weak self] _ in self?.run() }
        RunLoop.main.add(timer, forMode: .common)
    }

    private func findProjects(completion: @escaping ([ProjectLog]) -> Void) {
        let logs = XcodeLogFinder().findLogs(derivedDataURL: derivedDataURL)
        let filteredLogs = filterProjects(logs)
        log(.debug, dump(filteredLogs).debugDescription)
        xcodeLogManager.asyncReadProjectsLogs(logs: filteredLogs, completion: completion)
    }
}

// MARK: - Filtering by modificationDate

private extension EntryPoint {

    private func filterProjects(_ logs: [String : [URL]]) -> [String: [URL]] {
        var latestLogDate: Date?

        let filteredLogs: [String: [URL]] = logs.reduce(into: [:]) { dictionary, projectLogs in
            let (projectId, schemePaths) = projectLogs

            let filteredSchemePaths = schemePaths.filter { schemePath in
                guard
                    let modificationDate = fileModificationDate(atPath: schemePath.path),
                    needImportBuild(withModificationDate: modificationDate)
                else { return false }

                latestLogDate = max(latestLogDate, modificationDate)
                return true
            }

            if !filteredSchemePaths.isEmpty {
                dictionary[projectId] = filteredSchemePaths
            }
        }

        if let latestLogDate = latestLogDate {
            importProjectsDate = latestLogDate
        }

        return filteredLogs
    }

    private func fileModificationDate(atPath path: String) -> Date? {
        let attributes = try? FileManager.default.attributesOfItem(atPath: path)
        guard let modificationDate = attributes?[.modificationDate] as? Date else {
            log(.error, "Can't get modificationDate from file: \(path)")
            return nil
        }
        return modificationDate
    }

    private func needImportBuild(withModificationDate date: Date) -> Bool {
        guard let importProjectsDate = importProjectsDate else { return true }
        return importProjectsDate < date
    }

    private func max(_ lhs: Date?, _ rhs: Date) -> Date {
        guard let lhs = lhs else { return rhs }
        return Swift.max(lhs, rhs)
    }
}

private extension Array where Element == Project {

    func output() -> String {
        debugDescription
    }
}

/*
private func testProjectLogs() -> [ProjectLog] {
    return [
        ProjectLog(id: "-1",
                   name: "SMEReputation",
                   schemes: [
                    ProjectLog.Scheme(
                        id: "1",
                        name: "1",
                        startDate: Date(),
                        buildStatus: true,
                        duration: 100
                    ),
                    ProjectLog.Scheme(
                        id: "2",
                        name: "1",
                        startDate: Date(),
                        buildStatus: false,
                        duration: 200
                    ),
                    ProjectLog.Scheme(
                        id: "3",
                        name: "1",
                        startDate: Date(),
                        buildStatus: false,
                        duration: 300
                    ),
                    ProjectLog.Scheme(
                        id: "4",
                        name: "1",
                        startDate: Date(),
                        buildStatus: true,
                        duration: 100
                    ),
                    ProjectLog.Scheme(
                        id: "5",
                        name: "1",
                        startDate: Date(),
                        buildStatus: false,
                        duration: 100
                    )
            ]
        ),

        ProjectLog(id: "0",
                   name: "Buildyosh",
                   schemes: [
                    ProjectLog.Scheme(
                        id: "1",
                        name: "1",
                        startDate: Date(),
                        buildStatus: false,
                        duration: 400
                    ),
                    ProjectLog.Scheme(
                        id: "1",
                        name: "1",
                        startDate: Date(),
                        buildStatus: true,
                        duration: 400
                    )
            ]
        ),
        ProjectLog(id: "0",
                   name: "Buildyosh",
                   schemes: [
                    ProjectLog.Scheme(
                        id: "1",
                        name: "1",
                        startDate: Date().yesterday,
                        buildStatus: false,
                        duration: 1000
                    )
            ]
        ),

        ProjectLog(id: "1",
                   name: "Frog",
                   schemes: [
                    ProjectLog.Scheme(
                        id: "1",
                        name: "1",
                        startDate: Date(),
                        buildStatus: false,
                        duration: 300
                    ),
                    ProjectLog.Scheme(
                        id: "1",
                        name: "1",
                        startDate: Date(),
                        buildStatus: false,
                        duration: 100
                    )
            ]
        ),
        ProjectLog(id: "2",
                   name: "SwiftyFinch",
                   schemes: [
                    ProjectLog.Scheme(
                        id: "1",
                        name: "1",
                        startDate: Date(),
                        buildStatus: true,
                        duration: 200
                    )
            ]
        ),

        ProjectLog(id: "3",
                   name: "Chester",
                   schemes: [
                    ProjectLog.Scheme(
                        id: "1",
                        name: "1",
                        startDate: Date().beginOfWeek.yesterday,
                        buildStatus: true,
                        duration: 2000
                    )
            ]
        ),
        ProjectLog(id: "4",
                   name: "ThisIsAVeryLongNameOfProject",
                   schemes: [
                    ProjectLog.Scheme(
                        id: "1",
                        name: "1",
                        startDate: Date(),
                        buildStatus: true,
                        duration: 500
                    )
            ]
        )
    ]
}
*/
