//
//  ProjectLog.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 12.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

struct ProjectLog {

    struct Scheme {
        let id: String
        let name: String
        let startDate: Date
        let buildStatus: Bool
        let duration: Double
    }

    let id: String
    let name: String
    let schemes: [Scheme]
}
