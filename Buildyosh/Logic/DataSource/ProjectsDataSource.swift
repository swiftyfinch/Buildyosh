//
//  ProjectsDataSource.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 28.06.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

final class ProjectsDataSource: ObservableObject {

    @Published var filterType: Int = 0 {
        didSet { filter() }
    }
    private var sourceProjects: [Project] = []
    @Published var projects: [Project] = []
    private(set) var duration: Duration?

    private let dateFilter: ProjectsDateFilter
    private let countFilter: ProjectsCountFilter
    private let totalModifier: TotalModifier

    init(dateFilter: ProjectsDateFilter,
         countFilter: ProjectsCountFilter,
         totalModifier: TotalModifier) {
        self.dateFilter = dateFilter
        self.countFilter = countFilter
        self.totalModifier = totalModifier
    }

    func save(projects: [Project]) {
        self.sourceProjects = projects
        filter()
    }

    private func filter() {
        guard let filter = ProjectsDateFilter.DateFilter(rawValue: filterType) else {
            fatalError()
        }
        let dateFiltered = dateFilter.filter(sourceProjects, by: filter)
        let countFiltered = countFilter.filter(dateFiltered)
        duration = totalModifier.duration(countFiltered)
        projects = countFiltered
    }
}
