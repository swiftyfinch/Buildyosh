//
//  Action.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 20.09.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

enum Action {
    case beginLoading
    case changeProgress(_ value: Double)
    case endLoading

    case changePeriodType(_ periodType: Int)
    case updatePeriods(periods: Periods)

    case changeMode
    case toggleAbout
}
