//
//  Date+Int.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 29.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

extension Date {

    var int: Int {
        let calendar = Calendar.current
        let day = calendar.component(.day, from: self)
        let month = calendar.component(.month, from: self)
        let year = calendar.component(.year, from: self)
        return day * 1_000_000 + month * 10_000 + year
    }
}
