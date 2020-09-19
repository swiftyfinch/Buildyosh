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
    }

    private func buildStatusBarItem() -> NSStatusItem {
        let statusBar = NSStatusBar.system
        let statusBarItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)

        let image = NSImage(named: "gear")
        statusBarItem.button?.image = image

        statusBarItem.button?.target = self
        statusBarItem.button?.action = #selector(statusBarButtonClicked(_:))
        statusBarItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])

        return statusBarItem
    }

    @objc private func statusBarButtonClicked(_ sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }

        if event.type == .rightMouseUp {
            let menu = NSMenu()
            let item = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "")
            item.target = self
            menu.items = [item]
            statusBarItem?.showMenu(menu)
        } else {
            let menu = NSMenu()
            let item = NSMenuItem()
            item.view = NSHostingView(rootView: rootView)
            item.view?.frame = CGRect(origin: .zero, size: model.size)
            menu.items = [item]

            model.$size.sink { size in
                item.view?.frame.size = size
            }.store(in: &cancellables)

            statusBarItem?.showMenu(menu)
        }
    }

    @objc private func quit() {
        NSApplication.shared.terminate(self)
    }
}

private extension NSStatusItem {

    func showMenu(_ menu: NSMenu) {
        self.menu = menu
        button?.performClick(nil)
        self.menu = nil
    }
}
