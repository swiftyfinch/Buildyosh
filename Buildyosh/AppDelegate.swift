//
//  AppDelegate.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 25.06.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Cocoa
import SwiftUI
import Watchdog

// sfsymbols --symbol-name multiply.circle --font-size 18 --format pdf --font-weight black

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {

    #if DEBUG
    private let watchdog = Watchdog(threshold: 0.4, strictMode: false)
    #endif

    private var entryPoint: EntryPoint?
    private var windowManager: AnyObject?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let store = Store(initialState: MainState(), reducer: Reducer().reduce)
        let xcodeLogManager = XcodeLogAsyncParser(store: store)
        entryPoint = EntryPoint(store: store, xcodeLogManager: xcodeLogManager)

        let contentView = ContentView().environmentObject(store)
        let windowManager = WindowManager(store: store, rootView: contentView)
        self.windowManager = windowManager

        windowManager.buildAndPresent {
            if let key = KeychainService().getKey() {
                store.send(.verifyKey(key))
            } else {
                store.send(.beginOnboarding)
            }
        }
    }
}
