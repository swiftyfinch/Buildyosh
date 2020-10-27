//
//  KeychainService.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 29.09.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation
import KeychainAccess

final class KeychainService {
    let keychain = Keychain(service: Bundle.main.bundleIdentifier!)

    func saveKey(_ key: String) { keychain[.licence] = key }
    func hasKey() -> Bool { keychain[.licence] != nil }
    func getKey() -> String? { keychain[.licence] }
    func removeKey() { try? keychain.remove(.licence) }
}

private extension String {
    static let licence = "licence"
}
