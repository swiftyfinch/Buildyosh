//
//  ProjectsCountFilter.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 12.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct ProjectsCountFilter {

    func filter(_ projects: [Project]) -> [Project] {
        let notEmptyDuraton = projects.filter { $0.totalDuration > 0 }
        var sorted = notEmptyDuraton.sorted { $0.totalDuration > $1.totalDuration }

        var othersSchemes: [Project.Scheme] = []
        while sorted.count > 5 {
            let last = sorted.removeLast()
            othersSchemes.append(contentsOf: last.schemes)
        }

        if !othersSchemes.isEmpty {
            let others = Project(id: "Others",
                                 name: "Others",
                                 schemes: othersSchemes)
            sorted.append(others)
        }

        return sorted
    }
}
