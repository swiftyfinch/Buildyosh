//
//  PeriodParser.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 23.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct Periods: Equatable {
    let today: Period
    let yday: Period
    let week: Period
    let all: Period
}

extension Periods {
    func period(withType type: Period.PeriodType) -> Period {
        switch type {
        case .today: return today
        case .yday: return yday
        case .week: return week
        case .all: return all
        }
    }
}

struct NewProject {
    let id: String
    let name: String
    let duration: Double
    let count: Int
    let modifiedDate: Date
    let dates: [Int]
}

private struct Projects {
    private struct Content {
        let name: String
        var duration: Double
        var count: Int
        var modifiedDate: Date
        var successCount: Int
        var failCount: Int
        var dates: Set<Int> = []
    }
    private var content: [String: Content] = [:]

    mutating func addProject(log: ProjectLog, scheme: ProjectLog.Scheme) {
        let (id, name, duration, date) = (log.id, log.name, scheme.duration, scheme.startDate)
        let (successCount, failCount) = (scheme.buildStatus ? 1 : 0, scheme.buildStatus ? 0 : 1)
        var project: Content!
        if content[id] == nil {
            project = Content(name: name,
                              duration: duration,
                              count: 1,
                              modifiedDate: date,
                              successCount: successCount,
                              failCount: failCount)
        } else {
            project = content[id]
            project.duration += duration
            project.count += 1
            project.modifiedDate = max(date, project.modifiedDate)
            project.successCount += successCount
            project.failCount += failCount
        }
        project.dates.insert(date.int)
        content[id] = project
    }

    func make() -> [Project] {
        content.map { id, project in
            Project(id: id,
                    name: project.name,
                    duration: project.duration,
                    count: project.count,
                    daysCount: project.dates.count,
                    modifiedDate: project.modifiedDate,
                    successCount: project.successCount,
                    failCount: project.failCount,
                    dates: project.dates)
        }.sorted {
            $0.name < $1.name
        }
    }
}

struct PeriodParser {
    func splitLogsToPeriods(_ logs: [ProjectLog], relativeDate: Date) -> Periods {
        var todayProjects = Projects()
        var ydayProjects = Projects()
        var weekProjects = Projects()
        var allProjects = Projects()

        for log in logs {
            for scheme in log.schemes.sorted(by: { $0.startDate < $1.startDate }) {
                if scheme.startDate.isInSameDay(as: relativeDate) {
                    todayProjects.addProject(log: log, scheme: scheme)
                } else if scheme.startDate.isInSameDay(as: relativeDate.yesterday) {
                    ydayProjects.addProject(log: log, scheme: scheme)
                }

                if scheme.startDate.isInSameWeek(as: relativeDate) {
                    weekProjects.addProject(log: log, scheme: scheme)
                }
                allProjects.addProject(log: log, scheme: scheme)
            }
        }

        let today = relativeDate.beginOfDay
        let todayPeriod = Period(date: today, type: .today, projects: todayProjects.make())

        let yday = today.yesterday
        let ydayPeriod = Period(date: yday, type: .yday, projects: ydayProjects.make())

        let week = today.beginOfWeek
        let weekPeriod = Period(date: week, type: .week, projects: weekProjects.make())

        let allPeriod = Period(date: today, type: .all, projects: allProjects.make())

        return Periods(today: todayPeriod, yday: ydayPeriod, week: weekPeriod, all: allPeriod)
    }
}
