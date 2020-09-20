//
//  State.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 20.09.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct State {
    enum Mode: Int, CaseIterable {
        case time
        case count
        case success
    }

    var isLoaded = false
    var progress = 0.0

    var periods: Periods = Periods(
        today: Period(type: .today),
        yday: Period(type: .yday),
        week: Period(type: .week),
        all: Period(type: .all)
    )
    var periodType = 0
    var projects: [Project] = []
    var duration: Duration = .zero

    var mode: Mode = .time

    var isAboutShown = false

    var size: CGSize = .zero
}
