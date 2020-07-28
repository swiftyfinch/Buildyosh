//
//  Project.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 01.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct Project: Identifiable {
    struct Scheme: Identifiable {
        let id: String
        let name: String
        let startDate: Date
        let buildStatus: Bool
        let duration: Double
    }

    let id: String
    let name: String
    let schemes: [Scheme]

    var succeedCount: Int {
        schemes.filter(\.buildStatus).count
    }

    var failedCount: Int {
        schemes.filter { !$0.buildStatus }.count
    }

    var succeedRate: Int {
        if schemes.count == 0 {
            return 0
        } else {
            return Int(Double(succeedCount) / Double(schemes.count) * 100.0)
        }
    }

    var totalDuration: Double {
        schemes.reduce(0.0) { $0 + $1.duration }
    }
}
