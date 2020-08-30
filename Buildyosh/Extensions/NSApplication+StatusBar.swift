//
//  NSApplication+StatusBar.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 29.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import AppKit

extension String {
    static let privateStatusBarClass = "NSStatusBarWindow"
}

extension NSApplication {

    var statusBar: NSWindow? {
        windows.first(where: { type(of: $0).description() == .privateStatusBarClass })
    }

    var isStatusBarHidden: Bool {
        let screenFrame = NSScreen.main?.frame
        return statusBar?.frame.origin.y == screenFrame?.height
    }
}
