//
//  MainState.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 20.09.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct MainState {
    enum Mode: Int, CaseIterable {
        case time
        case count
        case success
    }
    var mode: Mode = .time

    var periods: Periods = Periods(
        today: Period(type: .today),
        yday: Period(type: .yday),
        week: Period(type: .week),
        all: Period(type: .all)
    )
    var periodType = 1
    var projects: [Project] = []
    var duration: Duration?

    enum Screen: Equatable {
        enum Onboarding: Equatable {
            case begin
            case loading
            case error(String)
            case finish
        }

        case loading
        case main
        case about
        case onboarding(Onboarding)
    }
    var screen: Screen = .main
    var progress = 0.0

    var size: CGSize = .zero
}
