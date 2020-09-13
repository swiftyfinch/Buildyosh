//
//  Model.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 12.09.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Combine
import SwiftUI

private extension CGFloat {
    static let width: CGFloat = 260
    static let loaderHeight: CGFloat = 60
    static let minAboutHeight: CGFloat = 180
}

final class Model: ObservableObject {

    @Published private var manager: XcodeLogAsyncParser
    @Published private var dataSource: ProjectsDataSource

    @Published private(set) var isLoaded = false
    @Published var progress: Double = 0 // Use bind in one way
    var needShowLoader: Bool { !manager.isLoaded && dataSource.projects.isEmpty }

    @Published private(set) var projects: [Project] = []
    @Published private(set) var duration = Duration(total: 0, perDay: 0, days: 0)
    @Published var filterType = 0
    @Published var successMode = false

    var isAboutShown = false {
        didSet {
            self.size = CGSize(width: .width, height: self.height)
            self.objectWillChange.send()
        }
    }

    @Published private(set) var size: CGSize = .zero
    @Published private(set) var isWaitForQuit: Bool = false

    private var width: CGFloat = .width
    private var height: CGFloat {
        var newHeight: CGFloat
        if !isLoaded && projects.isEmpty {
            newHeight = .loaderHeight
        } else {
            let contentHeight = ProjectsSection.height(
                projects: projects,
                duration: duration
            )
            if isAboutShown {
                newHeight = max(contentHeight, .minAboutHeight)
            } else {
                newHeight = contentHeight
            }
        }
        return newHeight
    }

    private var cancellables: Set<AnyCancellable> = []

    init(manager: XcodeLogAsyncParser, dataSource: ProjectsDataSource) {
        self.manager = manager
        self.dataSource = dataSource

        manager.$isLoaded.assign(to: \.isLoaded, on: self).store(in: &cancellables)
        manager.$progress.assign(to: \.progress, on: self).store(in: &cancellables)

        dataSource.$projects.sink { projects in
            self.projects = projects
            self.size = CGSize(width: .width, height: self.height)
            self.objectWillChange.send()
        }.store(in: &cancellables)

        dataSource.$projects.assign(to: \.projects, on: self).store(in: &cancellables)
        dataSource.$duration.assign(to: \.duration, on: self).store(in: &cancellables)
        dataSource.$filterType.assign(to: \.filterType, on: self).store(in: &cancellables)

        size = .zero
    }

    func quit() {
        isWaitForQuit = true
        objectWillChange.send()
    }
}
