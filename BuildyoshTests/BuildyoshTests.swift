//
//  BuildyoshTests.swift
//  BuildyoshTests
//
//  Created by Vyacheslav Khorkov on 01.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import XCTest
@testable import Buildyosh

final class BuildyoshTests: XCTestCase {

    func testPerformanceTotal() throws {
        measure {
            let testsPath = URL(fileURLWithPath: #file).deletingLastPathComponent()
            let derivedDataURL = testsPath.appendingPathComponent("DerivedData")

            let dataSource = ProjectsDataSource(dateFilter: ProjectsDateFilter(),
                                                countFilter: ProjectsCountFilter())
            dataSource.filterType = ProjectsDateFilter.DateFilter.allTime.rawValue
            let xcodeLogManager = XcodeLogAsyncParser(
                derivedDataURL: derivedDataURL,
                dataSource: dataSource
            )
            xcodeLogManager.readProjectsLogs()

            XCTAssertEqual(xcodeLogManager.dataSource.projects.count, 2)

            let project = xcodeLogManager.dataSource.projects[0]
            XCTAssertEqual(project.id, "Buildyosh-hcjlvgahnddmeghevdramwmzzqcv")
            XCTAssertEqual(project.name, "Buildyosh")
            XCTAssertEqual(project.succeedCount, 6)
            XCTAssertEqual(project.failedCount, 2)
            XCTAssertEqual(project.succeedRate, 75)
            XCTAssertEqual(project.totalDuration, 7.9530099630355835)

            let othersProject = xcodeLogManager.dataSource.projects[1]
            XCTAssertEqual(othersProject.id, "Others")
            XCTAssertEqual(othersProject.name, "Others")
            XCTAssertTrue(othersProject.schemes.isEmpty)

            let schemes = project.schemes
            XCTAssertEqual(schemes.map(\.id), [
                "E52949FE-F9FA-4860-A05F-5BA8CA52A341",
                "ED3BD57B-48B7-4185-8CF3-E18D0F671D72",
                "FD770A5C-6067-4872-B825-8E895047730A",
                "E65C3DDD-0ECE-4341-B34B-091E53ED5586",
                "FF7C3EE9-320F-424B-BCDE-C9ECDCF5BBA3",
                "EED5BFE6-A622-40F3-9796-08F8444B084C",
                "F2500ED2-FB00-4D38-8CF3-BFF4E6673A62",
                "EC5E17EF-26B4-4252-A82F-F61B1F722749"
            ])
            XCTAssertEqual(schemes.map(\.startDate.description), [
                "2020-07-01 12:00:37 +0000",
                "2020-07-01 13:19:19 +0000",
                "2020-07-01 13:30:18 +0000",
                "2020-07-01 12:21:09 +0000",
                "2020-07-01 11:23:25 +0000",
                "2020-07-01 12:37:26 +0000",
                "2020-07-01 11:23:42 +0000",
                "2020-07-01 11:37:27 +0000"
            ])
            XCTAssertEqual(project.schemes.map(\.buildStatus), [
                "succeeded",
                "succeeded",
                "succeeded",
                "succeeded",
                "failed",
                "succeeded",
                "failed",
                "succeeded"
            ])
            XCTAssertEqual(project.schemes.map(\.duration), [
                0.2805880308151245,
                1.2285820245742798,
                1.8841229677200317,
                0.28113603591918945,
                1.6538629531860352,
                0.19491004943847656,
                1.3734959363937378,
                1.0563119649887085
            ])
        }
    }
}
