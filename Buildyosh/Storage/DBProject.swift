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
    @NSManaged var schemes: Set<DBScheme>
}

extension DBProject {

    static func request() -> NSFetchRequest<NSFetchRequestResult> {
        NSFetchRequest<NSFetchRequestResult>(entityName: "Project")
    }

    var model: Project {
        Project(id: id,
                name: name,
                schemes: schemes.map(\.model))
    }
}

extension Project {

    @discardableResult
    func buildDB(context: NSManagedObjectContext) -> DBProject {
        let db = DBProject(context: context)
        db.id = id
        db.name = name
        db.schemes = schemes.reduce(into: []) { set, scheme in
            let db = scheme.buildDB(context: context)
            set.insert(db)
        }
        return db
    }
}
