//
//  WindowManager.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 23.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import AppKit
import SwiftUI
import Combine

final class WindowManager<Content: View> {

    private let rootView: Content
    private let model: Model

    private var statusBarItem: NSStatusItem?
    private var cancellables: Set<AnyCancellable> = []

    init(rootView: Content, model: Model) {
        self.rootView = rootView
        self.model = model
    }

    func buildAndPresent() {
        statusBarItem = buildStatusBarItem()

        model.$isWaitForQuit.sink { [weak self] isWaitForQuit in
            guard isWaitForQuit else { return }
            self?.quit()
        }.store(in: &cancellables)
    }

    private func buildStatusBarItem() -> NSStatusItem {
        let statusBar = NSStatusBar.system
        let statusBarItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)

        let image = NSImage(named: "gear")
        statusBarItem.button?.image = image

        let statusBarMenu = NSMenu()
        let item = NSMenuItem()
        item.view = NSHostingView(rootView: rootView)
        item.view?.frame = CGRect(origin: .zero, size: model.size)
        statusBarMenu.items = [item]
        statusBarItem.menu = statusBarMenu

        model.$size.sink { size in
            item.view?.frame.size = size
        }.store(in: &cancellables)

        return statusBarItem
    }

    @objc private func quit() {
        NSApplication.shared.terminate(self)
    }
}
