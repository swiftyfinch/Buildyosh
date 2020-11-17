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
        withPeriodType periodType: Int,
        isExpanded: Bool
    ) -> (projects: [Project], duration: Duration?) {
        let type = Period.PeriodType(rawValue: periodType)!
        let period = periods.period(withType: type)
        let projects = ProjectsCountFilter().filter(period.projects, isExpanded: isExpanded)
        let duration = periodType > 1 ? TotalModifier().duration(projects) : nil
        return (projects, duration)
    }
}
