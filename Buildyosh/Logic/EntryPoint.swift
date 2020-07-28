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
    private let xcodeLogManager: XcodeLogAsyncParser
    private let dataSource: ProjectsDataSource

    private var running = false
    private let timerInterval = 60.0 / 4

    init(xcodeLogManager: XcodeLogAsyncParser,
         dataSource: ProjectsDataSource) {
        self.xcodeLogManager = xcodeLogManager
        self.dataSource = dataSource
    }

    func run() {
        guard !running else { return }

        running = true
        storage.load { [weak self] result in
            guard let self = self else { return }

            switch result {
            case .success:
                self.findProjects { [weak self] projects in
                    guard let self = self else { return }

                    self.storage.saveProjects(projects) { [weak self] in
                        guard let self = self else { return }

                        let allProjects = self.storage.loadProjects()
                        self.dataSource.save(projects: allProjects)
                        self.running = false
                        log(.info, "Scan new projects. Found: \(projects.output())")
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
        Timer.scheduledTimer(withTimeInterval: timerInterval,
                             repeats: true) { [weak self] _ in self?.run() }
    }

    private func findProjects(completion: @escaping ([Project]) -> Void) {
        let logs = XcodeLogFinder().findLogs(derivedDataURL: derivedDataURL)
        let filteredLogs: [String: [URL]] = logs.reduce(into: [:]) { dictionary, projectLogs in
            let (projectId, schemePaths) = projectLogs
            guard !schemePaths.isEmpty else { return }

            // It's a new project. Get it with all schemes
            guard storage.hasProject(withIdentifier: projectId) else {
                dictionary[projectId] = schemePaths
                return
            }

            // Old project. Try to find new schemes
            let ids = schemePaths.map { $0.deletingPathExtension().lastPathComponent }
            let foundSchemes = storage.hasSchemes(ids: ids, inProject: projectId)
            let filteredSchemePaths = schemePaths.filter {
                let schemeId = $0.deletingPathExtension().lastPathComponent
                return !foundSchemes.contains(schemeId)
            }

            if !filteredSchemePaths.isEmpty {
                dictionary[projectId] = filteredSchemePaths
            }
        }

        xcodeLogManager.asyncReadProjectsLogs(logs: filteredLogs, completion: completion)
    }
}

private extension Array where Element == Project {

    func output() -> String {
        debugDescription
    }
}
