//
//  UserStorage.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 11.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

@propertyWrapper struct UserStorage<Value> {
    let key: String
    private let storage: UserDefaults = .standard

    init(_ key: String) { self.key = key }

    var wrappedValue: Value? {
        get { storage.value(forKey: key) as? Value }
        set { storage.setValue(newValue, forKey: key) }
    }
}
