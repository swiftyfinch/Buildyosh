//
//  Storage+Project.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 19.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import CoreData

private enum StorageError: Error {
    case cantFindPeriodWithType(String)
}

extension NSManagedObjectContext {
    func replaceAll<T: Persistance>(_ objects: [T]) throws {
        let request = NSBatchDeleteRequest(fetchRequest: T.request())
        try execute(request)
        objects.forEach { $0.makeDB(context: self) }
    }
}

extension Storage {

    func loadPeriods(relativeDate: Date) -> Periods? {
        do {
            return try findOrCreatePeriods(inContext: container.viewContext,
                                           relativeDate: relativeDate)
        } catch {
            log(error)
            return nil
        }
    }

    func saveProjects(_ projects: [ProjectLog], relativeDate: Date, completion: @escaping () -> Void) {
        container.performBackgroundTask { [weak self] context in
            guard let self = self else { return }
            do {
                let periods = try self.findOrCreatePeriods(inContext: context, relativeDate: relativeDate)
                let newPeriods = PeriodParser().splitLogsToPeriods(projects, relativeDate: relativeDate)
                let combinedPeriods = PeriodUnion().combine(periods: periods,
                                                            withNew: newPeriods,
                                                            relativeDate: relativeDate)
                try context.replaceAll([combinedPeriods.today,
                                        combinedPeriods.yday,
                                        combinedPeriods.week,
                                        combinedPeriods.all])
                try context.save()
            } catch {
                log(error)
            }
            DispatchQueue.asyncOnMain(completion)
        }
    }

    private func findOrCreatePeriods(inContext context: NSManagedObjectContext, relativeDate: Date) throws -> Periods {
        let request = Period.request()
        let dbs = try (context.fetch(request) as? [DBPeriod]) ?? []
        let todayDate = relativeDate.beginOfDay
        if dbs.isEmpty {
            return Periods(today: Period(date: todayDate, type: .today),
                           yday: Period(date: todayDate.yesterday, type: .yday),
                           week: Period(date: todayDate.beginOfWeek,type: .week),
                           all: Period(date: todayDate, type: .all))
        } else {
            let today = try findPeriod(withType: .today, in: dbs).model ?? Period(date: todayDate, type: .today)
            let yday = try findPeriod(withType: .yday, in: dbs).model ?? Period(date: todayDate.yesterday, type: .yday)
            let week = try findPeriod(withType: .week, in: dbs).model ?? Period(date: todayDate.beginOfWeek,type: .week)
            let all = try findPeriod(withType: .all, in: dbs).model ?? Period(date: todayDate, type: .all)
            return Periods(today: today, yday: yday, week: week, all: all)
        }
    }

    private func findPeriod(withType type: Period.PeriodType, in periods: [DBPeriod]) throws -> DBPeriod {
        guard let period = periods.first(where: { $0.type == type.rawValue }) else {
            throw StorageError.cantFindPeriodWithType(String(describing: type))
        }
        return period
    }
}
