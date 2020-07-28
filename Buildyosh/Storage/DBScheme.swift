//
//  DBScheme.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 19.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import CoreData

final class DBScheme: NSManagedObject {
    @NSManaged var id: String
    @NSManaged var name: String
    @NSManaged var duration: Double
    @NSManaged var buildStatus: Bool
    @NSManaged var startDate: Date
}

extension DBScheme {

    static func request() -> NSFetchRequest<NSFetchRequestResult> {
        NSFetchRequest<NSFetchRequestResult>(entityName: "Scheme")
    }
    
    var model: Project.Scheme {
        Project.Scheme(id: id,
                       name: name,
                       startDate: startDate,
                       buildStatus: buildStatus,
                       duration: duration)
    }
}

extension Project.Scheme {

    func buildDB(context: NSManagedObjectContext) -> DBScheme {
        let db = DBScheme(context: context)
        db.id = id
        db.name = name
        db.buildStatus = buildStatus
        db.startDate = startDate
        db.duration = duration
        return db
    }
}
