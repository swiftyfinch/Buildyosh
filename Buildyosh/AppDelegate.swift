//
//  AppDelegate.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 25.06.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Cocoa
import SwiftUI

// TODO:
// 1. Add os_logs
// 2. Total
// 3. New design?
// 4. New icon?

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {

    private var windowManager: AnyObject?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let xcodeLogManager = XcodeLogAsyncParser()
        let dataSource = ProjectsDataSource(dateFilter: ProjectsDateFilter(),
                                            countFilter: ProjectsCountFilter(),
                                            totalModifier: TotalModifier())
        let entryPoint = EntryPoint(xcodeLogManager: xcodeLogManager,
                                    dataSource: dataSource)

        let contentView = ContentView()
            .environmentObject(xcodeLogManager)
            .environmentObject(dataSource)
            .environmentObject(entryPoint)

        let windowManager = WindowManager(rootView: contentView)
        windowManager.buildAndPresent()
        self.windowManager = windowManager
        
        entryPoint.runRepeatedly()
    }
}
