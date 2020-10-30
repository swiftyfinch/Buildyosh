//
//  Period.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 30.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct Period: Equatable {

    enum PeriodType: Int {
        case today
        case yday
        case week
        case all
    }

    let date: Date
    let type: PeriodType
    let projects: [Project]

    init(date: Date = Date(),
         type: PeriodType,
         projects: [Project] = []) {
        self.date = date
        self.type = type
        self.projects = projects
    }
}
