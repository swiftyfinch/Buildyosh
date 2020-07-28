//
//  URL+Utils.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 19.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import CoreData

extension URL {
    func add(_ pathComponent: String) -> URL {
        appendingPathComponent(pathComponent)
    }
}

extension URL {
    static let appSupport = NSPersistentContainer.defaultDirectoryURL()
    static let home = FileManager.default.homeDirectoryForCurrentUser
    static let derivedData = home.add("Library/Developer/Xcode/DerivedData")
}
