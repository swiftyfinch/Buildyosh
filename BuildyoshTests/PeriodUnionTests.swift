//
//  PeriodUnionTests.swift
//  BuildyoshTests
//
//  Created by Vyacheslav Khorkov on 30.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import XCTest
import Buildyosh

final class PeriodUnionTests: XCTestCase {

    /// Monday, Jan 1, 2001
    private let sourceDate = Date(timeIntervalSinceReferenceDate: 0)

    func testEmptyUpdateEmptyOldPeriods() {
        let today = sourceDate.beginOfDay
        let old = Periods(today: Period(date: today, type: .today),
                          yday: Period(date: today.yesterday, type: .yday),
                          week: Period(date: today.beginOfWeek, type: .week),
                          all: Period(date: today, type: .all))
        let new = Periods(today: Period(date: today, type: .today),
                          yday: Period(date: today.yesterday, type: .yday),
                          week: Period(date: today.beginOfWeek, type: .week),
                          all: Period(date: today, type: .all))
        let result = PeriodUnion().combine(periods: old, withNew: new, relativeDate: today)

        XCTAssertEqual(result.today, old.today)
        XCTAssertEqual(result.yday, old.yday)
        XCTAssertEqual(result.week, old.week)
        XCTAssertEqual(result.all, old.all)
    }

    func testEmptyUpdateOldPeriods() {
        let today = sourceDate.beginOfDay
        let todayProject = Project(id: "0",
                                   name: "Frog",
                                   duration: 10,
                                   count: 1,
                                   daysCount: 1,
                                   modifiedDate: today,
                                   successCount: 0,
                                   failCount: 0)
        let ydayProject = Project(id: "0",
                                  name: "Frog",
                                  duration: 20,
                                  count: 1,
                                  daysCount: 1,
                                  modifiedDate: today.yesterday,
                                  successCount: 0,
                                  failCount: 0)
        let old = Periods(today: Period(date: today, type: .today, projects: [todayProject]),
                          yday: Period(date: today.yesterday, type: .yday, projects: [ydayProject]),
                          week: Period(date: today.beginOfWeek, type: .week, projects: [todayProject]),
                          all: Period(date: today, type: .all, projects: [todayProject]))
        let new = Periods(today: Period(date: today, type: .today),
                          yday: Period(date: today.yesterday, type: .yday),
                          week: Period(date: today.beginOfWeek, type: .week),
                          all: Period(date: today, type: .all))
        let result = PeriodUnion().combine(periods: old, withNew: new, relativeDate: today)

        XCTAssertEqual(result.today, Period(date: today, type: .today, projects: [todayProject]))
        XCTAssertEqual(result.yday, Period(date: today.yesterday, type: .yday, projects: [ydayProject]))
        XCTAssertEqual(result.week, Period(date: today.beginOfWeek, type: .week, projects: [todayProject]))
        XCTAssertEqual(result.all, Period(date: today, type: .all, projects: [todayProject]))
    }

    func testUpdateOldYdayPeriods() {
        let today = sourceDate.tomorrow.tomorrow.beginOfDay // ср
        let yesterday = today.yesterday
        let todayProject = Project(id: "0",
                                   name: "Frog",
                                   duration: 10,
                                   count: 1,
                                   daysCount: 1,
                                   modifiedDate: yesterday,
                                   successCount: 0,
                                   failCount: 0) // вт
        let ydayProject = Project(id: "1",
                                  name: "Numb",
                                  duration: 20,
                                  count: 1,
                                  daysCount: 1,
                                  modifiedDate: yesterday.yesterday,
                                  successCount: 0,
                                  failCount: 0) // пн
        let old = Periods(today: Period(date: yesterday, type: .today, projects: [todayProject]),
                          yday: Period(date: yesterday.yesterday, type: .yday, projects: [ydayProject]),
                          week: Period(date: today.beginOfWeek, type: .week, projects: [todayProject, ydayProject]),
                          all: Period(date: today, type: .all, projects: [todayProject, ydayProject]))
        let new = Periods(today: Period(date: today, type: .today),
                          yday: Period(date: today.yesterday, type: .yday),
                          week: Period(date: today.beginOfWeek, type: .week),
                          all: Period(date: today, type: .all))

        let result = PeriodUnion().combine(periods: old, withNew: new, relativeDate: today)

        XCTAssertEqual(result.today, Period(date: today, type: .today))
        XCTAssertEqual(result.yday, Period(date: today.yesterday, type: .yday, projects: [todayProject]))
        XCTAssertEqual(result.week, Period(date: today.beginOfWeek, type: .week, projects: [todayProject, ydayProject]))
        XCTAssertEqual(result.all, Period(date: today, type: .all, projects: [todayProject, ydayProject]))
    }

    func testUpdateOldPeriodsWithNew() {
        let today = sourceDate.tomorrow.tomorrow.beginOfDay // ср
        let yesterday = today.yesterday
        let todayProject = Project(id: "0",
                                   name: "Frog",
                                   duration: 10,
                                   count: 1,
                                   daysCount: 1,
                                   modifiedDate: yesterday,
                                   successCount: 0,
                                   failCount: 0) // вт
        let ydayProject = Project(id: "1",
                                  name: "Numb",
                                  duration: 20,
                                  count: 1,
                                  daysCount: 1,
                                  modifiedDate: yesterday.yesterday,
                                  successCount: 0,
                                  failCount: 0) // пн
        let old = Periods(today: Period(date: yesterday, type: .today, projects: [todayProject]),
                          yday: Period(date: yesterday.yesterday, type: .yday, projects: [ydayProject]),
                          week: Period(date: today.beginOfWeek, type: .week, projects: [todayProject, ydayProject]),
                          all: Period(date: today, type: .all, projects: [todayProject, ydayProject]))

        let newTodayProject = Project(id: "0",
                                      name: "Frog",
                                      duration: 11,
                                      count: 1,
                                      daysCount: 1,
                                      modifiedDate: today,
                                      successCount: 0,
                                      failCount: 0,
                                      dates: [today.int])
        let newYdayProject = Project(id: "0",
                                     name: "Frog",
                                     duration: 12,
                                     count: 1,
                                     daysCount: 1,
                                     modifiedDate: yesterday,
                                     successCount: 0,
                                     failCount: 0,
                                     dates: [yesterday.int])
        let newWeekProject = Project(id: "0",
                                     name: "Frog",
                                     duration: 23,
                                     count: 2,
                                     daysCount: 2,
                                     modifiedDate: today,
                                     successCount: 0,
                                     failCount: 0,
                                     dates: [today.int, yesterday.int])
        let new = Periods(today: Period(date: today, type: .today, projects: [newTodayProject]),
                          yday: Period(date: today.yesterday, type: .yday, projects: [newYdayProject]),
                          week: Period(date: today.beginOfWeek, type: .week, projects: [newWeekProject]),
                          all: Period(date: today, type: .all, projects: [newWeekProject]))

        let result = PeriodUnion().combine(periods: old, withNew: new, relativeDate: today)

        let resultYdayProject = Project(id: "0",
                                        name: "Frog",
                                        duration: 22,
                                        count: 2,
                                        daysCount: 1,
                                        modifiedDate: yesterday,
                                        successCount: 0,
                                        failCount: 0)
        let resultWeekProjects = [
            Project(id: "0",
                    name: "Frog",
                    duration: 33,
                    count: 3,
                    daysCount: 2,
                    modifiedDate: today,
                    successCount: 0,
                    failCount: 0),
            Project(id: "1",
                    name: "Numb",
                    duration: 20,
                    count: 1,
                    daysCount: 1,
                    modifiedDate: yesterday.yesterday,
                    successCount: 0,
                    failCount: 0)
        ]
        XCTAssertEqual(result.today, Period(date: today, type: .today, projects: [newTodayProject]))
        XCTAssertEqual(result.yday, Period(date: today.yesterday, type: .yday, projects: [resultYdayProject]))
        XCTAssertEqual(result.week, Period(date: today.beginOfWeek, type: .week, projects: resultWeekProjects))
        XCTAssertEqual(result.all, Period(date: today, type: .all, projects: resultWeekProjects))
    }
}
