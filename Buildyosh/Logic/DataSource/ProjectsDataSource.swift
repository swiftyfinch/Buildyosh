//
//  ProjectsDataSource.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 28.06.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

final class ProjectsDataSource: ObservableObject {

    @Published var projects: [Project] = []
    @Published var filterType: Int = 0 {
        didSet { filter() }
    }

    @Published var duration: Duration = .zero

    private var periods: Periods?
    private var period: Period? {
        guard let type = Period.PeriodType(rawValue: filterType) else { return nil }
        return periods?.period(withType: type)
    }

    private let countFilter: ProjectsCountFilter
    private let totalModifier: TotalModifier

    init(countFilter: ProjectsCountFilter,
         totalModifier: TotalModifier) {
        self.countFilter = countFilter
        self.totalModifier = totalModifier
    }

    func save(periods: Periods) {
        self.periods = periods
        filter()
    }

    private func filter() {
        guard let period = period else {
            return log(error: "Can't select period.")
        }

        let countFiltered = countFilter.filter(period.projects)
        duration = totalModifier.duration(countFiltered)

//        projects = countFiltered.map {
//            let name: String
//            if $0.name == "TCSSME" {
//                name = "Business"
//            } else if $0.name == "MobileBank" {
//                name = "WorkProject"
//            } else {
//                name = $0.name
//            }
//            return Project(id: $0.id,
//                           name: name,
//                           schemes: $0.schemes)
//        }

        projects = countFiltered
    }
}
