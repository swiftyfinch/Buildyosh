//
//  Logger.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 24.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import AppKit
import os.log

private extension OSLog {
    private static var subsystem = Bundle.main.bundleIdentifier!

    static let main = OSLog(subsystem: subsystem, category: "main")
}

func log(_ error: Error) {
    log(.error, error.localizedDescription)
}

func log(_ type: OSLogType, _ message: String) {
    log(type, "%{public}@", message)
}

func log(_ type: OSLogType, _ message: StaticString, _ args: CVarArg...) {
    os_log(type, log: .main, message, args)
}
