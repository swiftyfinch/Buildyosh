//
//  EasyScanner.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 11.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct EasyScanner {

    private var content: Substring

    init(_ content: String) {
        self.content = content[...]
    }

    @discardableResult
    mutating func scan(_ string: String) -> Bool {
        guard content.hasPrefix(string) else { return false }
        content = content.dropFirst(string.count)
        return true
    }

    mutating func scanUntil(character: Character, reversed: Bool = false) -> Substring? {
        if reversed {
            guard let index = content.lastIndex(where: { $0 == character }) else { return nil }
            let suffix = content[index...].dropFirst()
            content = content[...index]
            return suffix
        } else {
            guard let index = content.firstIndex(where: { $0 == character }) else { return nil }
            let prefix = content[..<index]
            content = content[index...]
            return prefix
        }
    }

    @discardableResult
    mutating func skip(reversed: Bool = false) -> Character? {
        if reversed {
            guard let last = content.last else { return nil }
            let secondLast = content.index(before: content.endIndex)
            content = content[..<secondLast]
            return last
        } else {
            guard let first = content.first else { return nil }
            content = content.dropFirst()
            return first
        }
    }

    //

    mutating func scanIntUntil(character: Character) -> Int? {
        guard let index = content.firstIndex(where: { $0 == character }) else { return nil }
        let prefix = content[..<index]
        guard let int = Int(prefix) else { return nil }
        content = content[index...]
        return int
    }

    mutating func scanDoubleUntil(character: Character) -> Double? {
        guard let index = content.firstIndex(where: { $0 == character }) else { return nil }
        let prefix = content[..<index]
        guard let uint64 = UInt64(prefix, radix: 16) else { return nil }
        content = content[index...]
        return Double(bitPattern: uint64.byteSwapped)
    }

    mutating func scan(count: Int) -> Substring? {
        let prefix = content.prefix(count)
        content = content.dropFirst(count)
        return prefix
    }
}
