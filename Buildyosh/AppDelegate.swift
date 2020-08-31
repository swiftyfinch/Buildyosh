//
//  AppDelegate.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 25.06.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Cocoa
import SwiftUI

@NSApplicationMain
final class AppDelegate: NSObject, NSApplicationDelegate {

    private var windowManager: AnyObject?

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        let model = Model()
        let xcodeLogManager = XcodeLogAsyncParser()
        let dataSource = ProjectsDataSource(countFilter: ProjectsCountFilter(),
                                            totalModifier: TotalModifier())
        let entryPoint = EntryPoint(xcodeLogManager: xcodeLogManager,
                                    dataSource: dataSource)

        let contentView = ContentView()
            .environmentObject(model)
            .environmentObject(xcodeLogManager)
            .environmentObject(dataSource)
            .environmentObject(entryPoint)

        let windowManager = WindowManager(rootView: contentView, model: model)
        windowManager.buildAndPresent()
        self.windowManager = windowManager
        
        entryPoint.runRepeatedly()
    }
}

final class Model: ObservableObject {
    @Published var isWindowShown = false

    var isStatusBarHidden: Bool {
        guard let screen = NSScreen.main else { return false }
        return screen.frame.height == screen.visibleFrame.height
    }
}
