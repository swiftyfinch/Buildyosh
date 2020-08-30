//
//  XcodeLogParser.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 11.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

private extension Character {
    static let int: Character = "#"
    static let className: Character = "%"
    static let classNameRef: Character = "@"
    static let string: Character = "\""
    static let double: Character = "^"
    static let null: Character = "-"
}

private extension EasyScanner {

    @discardableResult
    mutating func scanXcodeLogInt() -> Int? {
        guard let int = scanIntUntil(character: .int) else { return nil }
        skip()
        return int
    }

    @discardableResult
    mutating func scanXcodeLogClassName() -> Substring? {
        guard let name = scanUntil(character: .className) else { return nil }
        skip()
        return name
    }

    @discardableResult
    mutating func scanXcodeLogClassNameRef() -> Substring? {
        guard let nameRef = scanUntil(character: .classNameRef) else { return nil }
        skip()
        return nameRef
    }

    @discardableResult
    mutating func scanXcodeLogString() -> Substring? {
        guard let count = scanIntUntil(character: .string) else { return nil }
        skip()
        return scan(count: count)
    }

    @discardableResult
    mutating func scanXcodeLogDouble() -> Double? {
        guard let double = scanDoubleUntil(character: .double) else { return nil }
        skip()
        return double
    }

    @discardableResult
    mutating func scanXcodeLogBuildResult() -> Substring? {
        guard skip(reversed: true) == .null else { return nil }
        let buildResult = scanUntil(character: "\"", reversed: true)
        guard let result = buildResult?.components(separatedBy: " ").last else { return nil }
        return result[...]
    }
}

final class XcodeLogParser {

    func parse(logs: [String: [URL]], step: () -> Void = {}) -> [ProjectLog] {
        logs.compactMap { id, paths in
            guard let name = id.components(separatedBy: "-").first else { return nil }

            let schemes: [ProjectLog.Scheme] = paths.compactMap {
                let scheme = parse(logURL: $0)
                step()
                return scheme
            }

            return ProjectLog(
                id: id,
                name: name,
                schemes: schemes
            )
        }
    }

    func parse(logURL: URL) -> ProjectLog.Scheme? {
        let logReader = XcodeLogReader()
        let content: String
        do {
            content = try logReader.read(from: logURL)
        } catch {
            log(error)
            return nil
        }

        var scanner = EasyScanner(content)
        scanner.scan("SLF")
        scanner.scanXcodeLogInt()
        scanner.scanXcodeLogClassName()
        scanner.scanXcodeLogClassNameRef()
        scanner.scanXcodeLogInt()
        scanner.scanXcodeLogString()
        scanner.scanXcodeLogString()

        guard
            let name = scanner.scanXcodeLogString(),
            let startTimeInterval = scanner.scanXcodeLogDouble(),
            let endTimeInterval = scanner.scanXcodeLogDouble(),
            let buildStatus = scanner.scanXcodeLogBuildResult()
        else {
            return nil
        }

        let id = logURL.deletingPathExtension().lastPathComponent
        let duration = endTimeInterval - startTimeInterval
        let startDate = Date(timeIntervalSinceReferenceDate: startTimeInterval)
        let buildStatusBool = buildStatus == "succeeded"

        return ProjectLog.Scheme(id: id,
                                 name: String(name),
                                 startDate: startDate,
                                 buildStatus: buildStatusBool,
                                 duration: duration)
    }
}
