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
        var count = 0
        var daysCount = 0
        var successCount = 0
        var failCount = 0
        while sorted.count > 5 {
            let last = sorted.removeLast()
            duration += last.duration
            count += last.count
            daysCount += last.daysCount
            successCount += last.successCount
            failCount += last.failCount
        }

        if duration > 0 {
            let others = Project(id: "Others_id",
                                 name: "Others",
                                 duration: duration,
                                 count: count,
                                 daysCount: daysCount,
                                 modifiedDate: Date(),
                                 successCount: successCount,
                                 failCount: failCount,
                                 dates: [])
            sorted.append(others)
        }

        return sorted
    }
}
