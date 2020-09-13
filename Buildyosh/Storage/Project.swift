//
//  Project.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 30.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct Project: Equatable {
    let id: String
    let name: String
    let duration: Double
    let count: Int
    let daysCount: Int
    let modifiedDate: Date
    let successCount: Int
    let failCount: Int

    var dates: Set<Int> = []
}

extension Project {
    var successRate: Int {
        Int(Double(successCount) / Double(count) * 100)
    }
}
