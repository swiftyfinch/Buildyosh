//
//  DBPeriod.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 19.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import CoreData

protocol Persistance {
    associatedtype ManagedObject
    static func request() -> NSFetchRequest<NSFetchRequestResult>
    @discardableResult func makeDB(context: NSManagedObjectContext) -> ManagedObject
}

final class DBPeriod: NSManagedObject {
    @NSManaged var date: Date
    @NSManaged var type: Int
    @NSManaged var projects: Set<DBProject>
}

extension DBPeriod {

    var model: Period? {
        guard let periodType = Period.PeriodType(rawValue: type) else { return nil }
        return Period(date: date, type: periodType, projects: projects.map(\.model))
    }
}

extension Period: Persistance {

    static func request() -> NSFetchRequest<NSFetchRequestResult> {
        NSFetchRequest<NSFetchRequestResult>(entityName: "Period")
    }

    @discardableResult
    func makeDB(context: NSManagedObjectContext) -> DBPeriod {
        let db = DBPeriod(context: context)
        db.date = date
        db.type = type.rawValue
        db.projects = Set(projects.map { $0.makeDB(context: context) })
        return db
    }
}
