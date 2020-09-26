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

final class WindowManager<Content: View>: NSObject, NSMenuDelegate {

    private let store: Store<MainState, Action>
    private let rootView: Content

    private var hostingView: MenuHostingView<Content>
    private var statusBarItem: NSStatusItem?
    private var cancellables: Set<AnyCancellable> = []

    init(store: Store<MainState, Action>, rootView: Content) {
        self.store = store
        self.rootView = rootView

        self.hostingView = MenuHostingView(rootView: rootView)
    }

    func buildAndPresent(completion: @escaping () -> Void) {
        statusBarItem = buildStatusBarItem()

        // Need for testing loading state
        completion()
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
        event.type == .rightMouseUp ? showQuit() : showMain()
    }

    private func showQuit() {
        let menu = NSMenu()
        let item = NSMenuItem(title: "Quit",
                              action: #selector(quit),
                              keyEquivalent: "")
        item.target = self
        menu.items = [item]
        statusBarItem?.showMenu(menu)
    }

    private func showMain() {
        let item = NSMenuItem()
        item.view = hostingView
        item.view?.frame = CGRect(origin: .zero, size: store.state.size)

        store.$state.sink { state in
            item.view?.frame.size = state.size
        }.store(in: &cancellables)

        let menu = NSMenu()
        menu.delegate = self
        menu.items = [item]

        statusBarItem?.showMenu(menu)
    }

    @objc private func quit() {
        NSApplication.shared.terminate(self)
    }

    func menuDidClose(_ menu: NSMenu) {
        cancellables.forEach { $0.cancel() }
    }
}

private extension NSStatusItem {

    func showMenu(_ menu: NSMenu) {
        self.menu = menu
        button?.performClick(self)
        self.menu = nil
    }
}
