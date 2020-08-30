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
        let notEmptyDuraton = projects.filter { $0.duration > 0 }
        var sorted = notEmptyDuraton.sorted { $0.duration > $1.duration }

        var duration = 0.0
        while sorted.count > 5 {
            let last = sorted.removeLast()
            duration += last.duration
        }

//        if duration > 0 {
//            let others = Project(id: "Others",
//                                 name: "Others",
//                                 duration: duration,
//                                 count: 0,
//                                 daysCount: 0,
//                                 modifiedDate: Date())
//            sorted.append(others)
//        }

        return sorted
    }
}
