//
//  KeychainService.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 29.09.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import KeychainAccess

final class KeychainService {
    let keychain = Keychain(service: "com.swiftyfinch.Buildyosh")

    func saveKey(_ key: String) {
        keychain["licence"] = key
    }

    func getKey() -> String? {
        return keychain["licence"]
    }
}
