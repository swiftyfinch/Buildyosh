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

extension NSWindow {
    var isStatusBar: Bool {
        type(of: self).description() == .privateStatusBarClass
    }
}

extension NSApplication {

    var statusBar: NSWindow? {
        return windows.first(where: \.isStatusBar)
    }

    var isStatusBarHidden: Bool {
        let screenFrame = NSScreen.main?.frame
        return statusBar?.frame.origin.y == screenFrame?.height
    }

    var statusBarHeight: CGFloat {
        NSApplication.shared.statusBar?.frame.height ?? 0
    }

    var statusBarHiddenPosition: CGFloat {
        return NSScreen.main?.frame.height ?? 0
    }

    var statusBarShownPosition: CGFloat {
        let screenFrame = NSScreen.main?.frame.height ?? 0
        return screenFrame - statusBarHeight
    }
}
