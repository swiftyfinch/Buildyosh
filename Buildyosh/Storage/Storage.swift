//
//  Storage.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 17.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import CoreData

private extension String {
    static let db = "db"
    static let cache = "Cache"
}

final class Storage {
    private(set) var isLoaded = false
    let container = NSPersistentContainer(name: .db)

    private let dbDirectoryURL = URL.appSupport.add(.cache)
    private let dbURL = URL.appSupport.add(.cache).add(.db)

    init() {
        container.persistentStoreDescriptions = [.init(url: dbURL)]
    }

    func load(completion: @escaping (Result<Void>) -> Void) {
        guard !isLoaded else { return completion(.success) }

        do {
            try FileManager.createDirectoryIfNeeded(at: dbDirectoryURL)
        } catch {
            return completion(.failure(error))
        }

        container.loadPersistentStores { [weak self] description, error in
            if let error = error {
                completion(.failure(error))
            } else {
                self?.isLoaded = true
                completion(.success)
            }
        }
    }
}
