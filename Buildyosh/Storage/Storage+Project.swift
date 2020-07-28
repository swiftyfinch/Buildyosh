//
//  Storage+Project.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 19.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import CoreData

extension Storage {

    func hasProject(withIdentifier identifier: String) -> Bool {
        do {
            let request = DBProject.request()
            request.fetchLimit = 1
            request.resultType = .countResultType
            request.predicate = NSPredicate(format: "id == %@", identifier)
            let dbProjectsCount = (try container.viewContext.fetch(request) as? [Int])?[0] ?? 0
            if dbProjectsCount > 1 {
                log(.error, "Found %{public}@ projects with the same id.", dbProjectsCount)
            }
            return dbProjectsCount > 0
        } catch {
            log(error)
            return false
        }
    }

    func hasSchemes(ids: [String], inProject projectId: String) -> Set<String> {
        do {
            let request = DBScheme.request()
            request.propertiesToFetch = ["id"]
            request.resultType = .dictionaryResultType
            request.predicate = NSPredicate(format: "id in %@ AND project.id == %@", ids, projectId)
            let dbSchemes = try container.viewContext.fetch(request) as? [[String: String]] ?? []
            let foundIds = dbSchemes.compactMap(\.["id"])
            return Set(foundIds)
        } catch {
            log(error)
            return []
        }
    }

    func loadProjects() -> [Project] {
        do {
            let request = DBProject.request()
            request.returnsObjectsAsFaults = false
            let dbProjects = try container.viewContext.fetch(request) as? [DBProject]
            return dbProjects?.map(\.model) ?? []
        } catch {
            log(error)
            return []
        }
    }

    func saveProjects(_ projects: [Project], completion: @escaping () -> Void) {
        container.performBackgroundTask { context in
            do {
                for project in projects {
                    let request = DBProject.request()
                    request.predicate = NSPredicate(format: "id == %@", project.id)

                    if let db = try (context.fetch(request) as? [DBProject])?.first {
                        let schemes = project.schemes.map { $0.buildDB(context: context) }
                        db.schemes.formUnion(schemes)
                    } else {
                        project.buildDB(context: context)
                    }
                }

                try context.save()
            } catch {
                log(error)
            }

            DispatchQueue.asyncOnMain {
                completion()
            }
        }
    }
}
