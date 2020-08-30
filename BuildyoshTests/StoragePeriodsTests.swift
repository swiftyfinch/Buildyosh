//
//  StoragePeriodsTests.swift
//  BuildyoshTests
//
//  Created by Vyacheslav Khorkov on 23.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import XCTest
@testable import Buildyosh

final class StoragePeriodsTests: XCTestCase {

    /// Monday, Jan 1, 2001
    private let sourceDate = Date(timeIntervalSinceReferenceDate: 0)

    func testEmptyProject() {
        let emptyProject = ProjectLog(id: "0",
                                      name: "Frog",
                                      schemes: [])
        let periods = PeriodParser().splitLogsToPeriods([emptyProject],
                                                        relativeDate: sourceDate)

        let today = sourceDate.beginOfDay
        XCTAssertEqual(periods.today, Period(date: today, type: .today))

        let yday = today.yesterday
        XCTAssertEqual(periods.yday, Period(date: yday, type: .yday))

        let firstWeekDay = today.beginOfWeek
        XCTAssertEqual(periods.week, Period(date: firstWeekDay, type: .week))

        XCTAssertEqual(periods.all, Period(date: today, type: .all))
    }

    func testToday() {
        let scheme = ProjectLog.Scheme(id: "1",
                                       name: "Crack",
                                       startDate: sourceDate,
                                       buildStatus: true,
                                       duration: 10)
        let emptyProject = ProjectLog(id: "0",
                                      name: "Frog",
                                      schemes: [scheme])
        let periods = PeriodParser().splitLogsToPeriods([emptyProject],
                                                        relativeDate: sourceDate)

        let today = sourceDate.beginOfDay
        let todayProject = Project(id: "0",
                                   name: "Frog",
                                   duration: 10,
                                   count: 1,
                                   daysCount: 1,
                                   modifiedDate: sourceDate,
                                   dates: [sourceDate.int])
        let projects = [todayProject]
        XCTAssertEqual(periods.today,
                       Period(date: today, type: .today, projects: projects))

        let yday = today.yesterday
        XCTAssertEqual(periods.yday, Period(date: yday, type: .yday))

        let firstWeekDay = today.beginOfWeek
        XCTAssertEqual(periods.week,
                       Period(date: firstWeekDay, type: .week, projects: projects))

        XCTAssertEqual(periods.all,
                       Period(date: today, type: .all, projects: projects))
    }

    func testYesterday() {
        let scheme = ProjectLog.Scheme(id: "1",
                                       name: "Crack",
                                       startDate: sourceDate.yesterday,
                                       buildStatus: true,
                                       duration: 10)
        let emptyProject = ProjectLog(id: "0",
                                      name: "Frog",
                                      schemes: [scheme])
        let periods = PeriodParser().splitLogsToPeriods([emptyProject],
                                                        relativeDate: sourceDate)

        let today = sourceDate.beginOfDay
        let ydayProject = Project(id: "0",
                                  name: "Frog",
                                  duration: 10,
                                  count: 1,
                                  daysCount: 1,
                                  modifiedDate: sourceDate.yesterday,
                                  dates: [sourceDate.yesterday.int])
        let projects = [ydayProject]
        XCTAssertEqual(periods.today, Period(date: today, type: .today))

        let yday = today.yesterday
        XCTAssertEqual(periods.yday,
                       Period(date: yday, type: .yday, projects: projects))

        let firstWeekDay = today.beginOfWeek
        XCTAssertEqual(periods.week, Period(date: firstWeekDay, type: .week))

        XCTAssertEqual(periods.all,
                       Period(date: today, type: .all, projects: projects))
    }

    func testWeek() {
        let scheme = ProjectLog.Scheme(id: "1",
                                       name: "Crack",
                                       startDate: sourceDate.tomorrow.tomorrow,
                                       buildStatus: true,
                                       duration: 10)
        let emptyProject = ProjectLog(id: "0",
                                      name: "Frog",
                                      schemes: [scheme])
        let periods = PeriodParser().splitLogsToPeriods([emptyProject],
                                                        relativeDate: sourceDate)

        let today = sourceDate.beginOfDay
        let project = Project(id: "0",
                              name: "Frog",
                              duration: 10,
                              count: 1,
                              daysCount: 1,
                              modifiedDate: sourceDate.tomorrow.tomorrow,
                              dates: [sourceDate.tomorrow.tomorrow.int])
        let projects = [project]
        XCTAssertEqual(periods.today, Period(date: today, type: .today))

        let yday = today.yesterday
        XCTAssertEqual(periods.yday, Period(date: yday, type: .yday))

        let firstWeekDay = today.beginOfWeek
        XCTAssertEqual(periods.week,
                       Period(date: firstWeekDay, type: .week, projects: projects))

        XCTAssertEqual(periods.all,
                       Period(date: today, type: .all, projects: projects))
    }

    func testAll() {
        let scheme = ProjectLog.Scheme(id: "1",
                                       name: "Crack",
                                       startDate: sourceDate.yesterday.yesterday,
                                       buildStatus: true,
                                       duration: 10)
        let emptyProject = ProjectLog(id: "0",
                                      name: "Frog",
                                      schemes: [scheme])
        let periods = PeriodParser().splitLogsToPeriods([emptyProject],
                                                        relativeDate: sourceDate)

        let today = sourceDate.beginOfDay
        let project = Project(id: "0",
                              name: "Frog",
                              duration: 10,
                              count: 1,
                              daysCount: 1,
                              modifiedDate: sourceDate.yesterday.yesterday,
                              dates: [sourceDate.yesterday.yesterday.int])
        let projects = [project]
        XCTAssertEqual(periods.today, Period(date: today, type: .today))

        let yday = today.yesterday
        XCTAssertEqual(periods.yday, Period(date: yday, type: .yday))

        let firstWeekDay = today.beginOfWeek
        XCTAssertEqual(periods.week, Period(date: firstWeekDay, type: .week))

        XCTAssertEqual(periods.all,
                       Period(date: today, type: .all, projects: projects))
    }

    func testManySchemes() {
        let schemes = [
            ProjectLog.Scheme(id: "1",
                              name: "Crack",
                              startDate: sourceDate,
                              buildStatus: true,
                              duration: 10),
            ProjectLog.Scheme(id: "2",
                              name: "Crack",
                              startDate: sourceDate,
                              buildStatus: false,
                              duration: 10),
            ProjectLog.Scheme(id: "3",
                              name: "Crack",
                              startDate: sourceDate,
                              buildStatus: false,
                              duration: 10)
        ]
        let logProject = ProjectLog(id: "0",
                                    name: "Frog",
                                    schemes: schemes)
        let periods = PeriodParser().splitLogsToPeriods([logProject],
                                                        relativeDate: sourceDate)

        let today = sourceDate.beginOfDay
        let project = Project(id: "0",
                              name: "Frog",
                              duration: 30,
                              count: 3,
                              daysCount: 1,
                              modifiedDate: sourceDate,
                              dates: [sourceDate.int])
        let projects = [project]
        XCTAssertEqual(periods.today, Period(date: today, type: .today, projects: projects))

        let yday = today.yesterday
        XCTAssertEqual(periods.yday, Period(date: yday, type: .yday))

        let firstWeekDay = today.beginOfWeek
        XCTAssertEqual(periods.week,
                       Period(date: firstWeekDay, type: .week, projects: projects))

        XCTAssertEqual(periods.all,
                       Period(date: today, type: .all, projects: projects))
    }

    func testManyProjects() {
        let logProjects = [
            ProjectLog(id: "p0",
                       name: "Frog",
                       schemes: [ProjectLog.Scheme(id: "s1",
                                                   name: "Crack",
                                                   startDate: sourceDate,
                                                   buildStatus: true,
                                                   duration: 10),
                                 ProjectLog.Scheme(id: "s2",
                                                   name: "Crack",
                                                   startDate: sourceDate,
                                                   buildStatus: true,
                                                   duration: 10)]),
            ProjectLog(id: "p1",
                       name: "Plane",
                       schemes: [ProjectLog.Scheme(id: "s3",
                                                   name: "Task",
                                                   startDate: sourceDate,
                                                   buildStatus: true,
                                                   duration: 20),
                                 ProjectLog.Scheme(id: "s4",
                                                   name: "Task",
                                                   startDate: sourceDate,
                                                   buildStatus: true,
                                                   duration: 5)])
        ]
        let periods = PeriodParser().splitLogsToPeriods(logProjects,
                                                        relativeDate: sourceDate)

        let today = sourceDate.beginOfDay
        let projects = [
            Project(id: "p0",
                    name: "Frog",
                    duration: 20,
                    count: 2,
                    daysCount: 1,
                    modifiedDate: sourceDate,
                    dates: [sourceDate.int]),
            Project(id: "p1",
                    name: "Plane",
                    duration: 25,
                    count: 2,
                    daysCount: 1,
                    modifiedDate: sourceDate,
                    dates: [sourceDate.int])
        ]
        XCTAssertEqual(periods.today, Period(date: today, type: .today, projects: projects))

        let yday = today.yesterday
        XCTAssertEqual(periods.yday, Period(date: yday, type: .yday))

        let firstWeekDay = today.beginOfWeek
        XCTAssertEqual(periods.week,
                       Period(date: firstWeekDay, type: .week, projects: projects))

        XCTAssertEqual(periods.all,
                       Period(date: today, type: .all, projects: projects))
    }

    // MARK: - daysCount + dates + modifiedDate

    func testDaysCount() {
        let schemes = [
            ProjectLog.Scheme(id: "1",
                              name: "Crack",
                              startDate: sourceDate,
                              buildStatus: true,
                              duration: 10),
            ProjectLog.Scheme(id: "2",
                              name: "Crack",
                              startDate: sourceDate.tomorrow,
                              buildStatus: false,
                              duration: 10),
            ProjectLog.Scheme(id: "3",
                              name: "Crack",
                              startDate: sourceDate.tomorrow.tomorrow,
                              buildStatus: false,
                              duration: 10)
        ]
        let logProject = ProjectLog(id: "0",
                                    name: "Frog",
                                    schemes: schemes)
        let periods = PeriodParser().splitLogsToPeriods([logProject],
                                                        relativeDate: sourceDate)

        let today = sourceDate.beginOfDay
        let todayProject = Project(id: "0",
                                   name: "Frog",
                                   duration: 10,
                                   count: 1,
                                   daysCount: 1,
                                   modifiedDate: sourceDate,
                                   dates: [sourceDate.int])
        XCTAssertEqual(periods.today, Period(date: today, type: .today, projects: [todayProject]))

        let yday = today.yesterday
        XCTAssertEqual(periods.yday, Period(date: yday, type: .yday))

        let firstWeekDay = today.beginOfWeek
        let weekProject = Project(id: "0",
                                  name: "Frog",
                                  duration: 30,
                                  count: 3,
                                  daysCount: 3,
                                  modifiedDate: sourceDate.tomorrow.tomorrow,
                                  dates: [sourceDate.int,
                                          sourceDate.tomorrow.int,
                                          sourceDate.tomorrow.tomorrow.int])
        XCTAssertEqual(periods.week,
                       Period(date: firstWeekDay, type: .week, projects: [weekProject]))

        XCTAssertEqual(periods.all,
                       Period(date: today, type: .all, projects: [weekProject]))
    }
}
