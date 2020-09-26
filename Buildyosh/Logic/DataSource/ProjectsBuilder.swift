//
//  ProjectsBuilder.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 20.09.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct ProjectsBuilder {
    func build(
        fromPeriods periods: Periods,
        withPeriodType periodType: Int
    ) -> (projects: [Project], duration: Duration) {
        let type = Period.PeriodType(rawValue: periodType)!
        let period = periods.period(withType: type)
        let projects = ProjectsCountFilter().filter(period.projects)
        let duration = TotalModifier().duration(projects)
        return (projects, duration)
    }
}