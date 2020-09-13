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
    let buildCount: Int
    let successRate: Int

    static var zero = Duration(total: 0, perDay: 0, days: 0, buildCount: 0, successRate: 0)
}

struct TotalModifier {

    func duration(_ projects: [Project]) -> Duration {
        let daysCount = projects.max { $0.daysCount < $1.daysCount }?.daysCount ?? 0
        let totalDuration = projects.reduce(0) { $0 + $1.duration }
        let durationPerDay = daysCount > 0 ? totalDuration / Double(daysCount) : 0
        let buildCount = projects.reduce(0) { $0 + $1.count }
        let successBuilds = projects.reduce(0) { $0 + $1.successCount }
        let successRate = Int(Double(successBuilds) / Double(buildCount) * 100)
        return Duration(total: totalDuration,
                        perDay: durationPerDay,
                        days: daysCount,
                        buildCount: buildCount,
                        successRate: successRate)
    }
}
