//
//  Date+Periods.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 17.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

extension Date {

    var beginOfDay: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents(in: .current, from: self)
        components.hour = 0
        components.minute = 0
        components.second = 0
        components.nanosecond = 0
        return calendar.date(from: components)!
    }

    var yesterday: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents(in: .current, from: self)
        components.day = (components.day ?? 0) - 1
        return calendar.date(from: components)!
    }

    var tomorrow: Date {
        let calendar = Calendar.current
        var components = calendar.dateComponents(in: .current, from: self)
        components.day = (components.day ?? 0) + 1
        return calendar.date(from: components)!
    }

    var beginOfWeek: Date {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self)
        return calendar.date(from: components)!.beginOfDay
    }
}
