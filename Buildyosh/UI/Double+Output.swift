//
//  Double+Output.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 23.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

extension Double {

    func outputPercent() -> String {
        String(Int(self * 100.0)) + "%"
    }

    func outputDuration() -> String {
        let sec = Int(self)
        let (h, m, s) = (sec / 3600, (sec % 3600) / 60, (sec % 3600) % 60)
        var components: [String] = []
        if h > 0 { components.append("\(h)h") }
        if m > 0 { components.append("\(m)m") }
        if s > 0 { components.append("\(s)s") }
        return components.isEmpty ? "0s" : components.joined(separator: " ")
    }
}
