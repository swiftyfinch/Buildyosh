//
//  DBProject.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 17.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import CoreData

final class DBProject: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var duration: Double
    @NSManaged var count: Int
    @NSManaged var daysCount: Int
    @NSManaged var modifiedDate: Date
    @NSManaged var successCount: Int
    @NSManaged var failCount: Int
}

extension DBProject {
    var model: Project {
        Project(id: id,
                name: name,
                duration: duration,
                count: count,
                daysCount: daysCount,
                modifiedDate: modifiedDate,
                successCount: successCount,
                failCount: failCount)
    }
}

extension Project: Persistance {

    static func request() -> NSFetchRequest<NSFetchRequestResult> {
        NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
    }

    @discardableResult
    func makeDB(context: NSManagedObjectContext) -> DBProject {
        let db = DBProject(context: context)
        db.id = id
        db.name = name
        db.duration = duration
        db.count = count
        db.daysCount = daysCount
        db.modifiedDate = modifiedDate
        db.successCount = successCount
        db.failCount = failCount
        return db
    }
}
