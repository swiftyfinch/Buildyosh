//
//  PeriodUnion.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 23.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

private extension Period {
    func appending(_ newPeriod: Period) -> Period {
        if Set(newPeriod.projects.map(\.id)).count != newPeriod.projects.count {
            assertionFailure("There are projects with duplicated ids.")
        }

        var projectByIds: [String: Project] = projects.reduce(into: [:]) { $0[$1.id] = $1 }
        for project in newPeriod.projects {
            if let existProject = projectByIds[project.id] {
                var daysCount = existProject.daysCount + project.daysCount
                // Если дата в бд встречается в новых билдах, то не учитываем её повторно
                if project.dates.contains(existProject.modifiedDate.int) {
                    daysCount -= 1
                }

                projectByIds[project.id] = Project(id: project.id,
                                                   name: project.name,
                                                   duration: existProject.duration + project.duration,
                                                   count: existProject.count + project.count,
                                                   daysCount: daysCount,
                                                   modifiedDate: max(existProject.modifiedDate, project.modifiedDate))
            } else {
                projectByIds[project.id] = project
            }
        }
        let projects = Array(projectByIds.values).sorted {
            $0.name < $1.name
        }
        return Period(date: date, type: type, projects: projects)
    }
}

struct PeriodUnion {
    func combine(periods: Periods,
                 withNew newPeriods: Periods,
                 relativeDate: Date) -> Periods {
        let updatedPeriods = updatePeriods(periods, relativeDate: relativeDate)
        return Periods(today: updatedPeriods.today.appending(newPeriods.today),
                       yday: updatedPeriods.yday.appending(newPeriods.yday),
                       week: updatedPeriods.week.appending(newPeriods.week),
                       all: updatedPeriods.all.appending(newPeriods.all))
    }

    private func updatePeriods(_ periods: Periods, relativeDate: Date) -> Periods {
        let todayDate = relativeDate.beginOfDay
        var today = periods.today

        // Если вчера уже не вчера
        // Возможно сегодня стало вчера
        var yday = periods.yday
        let yesterday = todayDate.yesterday
        if !yday.date.isInSameDay(as: yesterday) {
            if today.date.isInSameDay(as: yesterday) {
                yday = Period(date: yesterday, type: .yday, projects: today.projects)
            } else {
                yday = Period(date: yesterday, type: .yday)
            }
        }

        if !today.date.isInSameDay(as: todayDate) {
            today = Period(date: todayDate, type: .today)
        }

        var week = periods.week
        let beginOfWeek = todayDate.beginOfWeek
        if !week.date.isInSameDay(as: beginOfWeek) {
            week = Period(date: beginOfWeek, type: .week)
        }

        return Periods(today: today, yday: yday, week: week, all: periods.all)
    }
}
