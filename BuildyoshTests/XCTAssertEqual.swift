//
//  XCTAssertEqual.swift
//  BuildyoshTests
//
//  Created by Vyacheslav Khorkov on 30.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import XCTest

public func XCTAssertEqual<T: Equatable>(_ expected: T, _ received: T, file: StaticString = #filePath, line: UInt = #line) {
    XCTAssertTrue(expected == received,
                  "Found difference for \n" + diff(expected, received).joined(separator: ", "),
                  file: file,
                  line: line)
}
