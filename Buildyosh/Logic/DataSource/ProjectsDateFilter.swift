//
//  ProjectsDateFilter.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 12.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct ProjectsDateFilter {

    enum DateFilter: Int {
        case today, yesterday, thisWeek, allTime
    }

    func filter(_ projects: [Project], by filter: DateFilter) -> [Project] {
        projects
            .filter { !$0.schemes.isEmpty }
            .map {
                let schemes = $0.schemes.filter {
                    switch filter {
                    case .today:
                        return $0.startDate.isInToday

                    case .yesterday:
                        return $0.startDate.isInYesterday

                    case .thisWeek:
                        return $0.startDate.isInThisWeek

                    case .allTime:
                        return true
                    }

                }
                return Project(
                    id: $0.id,
                    name: $0.name,
                    schemes: schemes
                )
        }
    }
}
