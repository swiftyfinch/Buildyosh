//
//  TotalModifier.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 26.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct Duration {
    let total: Double
    let perDay: Double
    let days: Int
}

final class TotalModifier {

    func duration(_ projects: [Project]) -> Duration {
        var daysCount = 0
        var totalDuration = 0.0
        for project in projects {
            daysCount += Set(project.schemes.map(\.startDate.dateInt)).count
            totalDuration += project.totalDuration
        }
        let durationPerDay = totalDuration / Double(daysCount)
        return Duration(total: totalDuration,
                        perDay: durationPerDay,
                        days: daysCount)
    }
}

private extension Date {

    var dateInt: Int {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        return day * 1_000_000 + month * 1_000 + year
    }
}
