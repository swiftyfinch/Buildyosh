//
//  DispatchQueue+Main.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 12.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

extension DispatchQueue {

    static func asyncOnMain(_ block: @escaping () -> Void) {
        if !Thread.isMainThread {
            DispatchQueue.main.async {
                block()
            }
        } else {
            block()
        }
    }
}
