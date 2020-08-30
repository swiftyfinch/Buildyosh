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

struct TotalModifier {

    func duration(_ projects: [Project]) -> Duration {
        let daysCount = projects.max { $0.daysCount < $1.daysCount }?.daysCount ?? 0
        let totalDuration = projects.reduce(0) { $0 + $1.duration }
        let durationPerDay = daysCount > 0 ? totalDuration / Double(daysCount) : 0
        return Duration(total: totalDuration,
                        perDay: durationPerDay,
                        days: daysCount)
    }
}
