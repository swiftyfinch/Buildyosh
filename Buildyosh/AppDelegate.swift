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

// TODO:
// 1. Залипают кнопки

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {

    private let watchdog = Watchdog(threshold: 0.4, strictMode: false)
    private var windowManager: AnyObject?
    private var entryPoint: EntryPoint?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let xcodeLogManager = XcodeLogAsyncParser()
        let dataSource = ProjectsDataSource(countFilter: ProjectsCountFilter(),
                                            totalModifier: TotalModifier())
        entryPoint = EntryPoint(xcodeLogManager: xcodeLogManager, dataSource: dataSource)

        let model = Model(manager: xcodeLogManager, dataSource: dataSource)
        let contentView = ContentView()
            .environmentObject(model)
            .environmentObject(dataSource)

        let windowManager = WindowManager(rootView: contentView, model: model)
        windowManager.buildAndPresent()
        self.windowManager = windowManager
        
        entryPoint?.runRepeatedly()
    }
}
