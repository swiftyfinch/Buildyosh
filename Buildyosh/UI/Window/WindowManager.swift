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

    // TODO: Move to Store
    @UserStorage("derivedDataPaths")
    private var derivedDataPaths: [String]?

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

        if let paths = derivedDataPaths, !paths.isEmpty {
            let title = NSMenuItem(title: "Delete DerivedData Path:", action: nil, keyEquivalent: "")
            menu.items.append(title)

            for path in paths {
                let deleteItem = NSMenuItem(title: URL(fileURLWithPath: path).pathAbbreviatingWithTilde,
                                            action: #selector(removeUserDefaultsPath(_:)),
                                            keyEquivalent: "")
                deleteItem.target = self
                menu.items.append(deleteItem)
            }
            menu.items.append(NSMenuItem.separator())
        }

        let title = NSMenuItem(title: "Add DerivedData Path:", action: nil, keyEquivalent: "")
        menu.items.append(title)
        let selectItem = NSMenuItem(title: "Select...",
                                    action: #selector(selectDerivedData(_:)),
                                    keyEquivalent: "")
        selectItem.target = self
        menu.items.append(selectItem)
        menu.items.append(NSMenuItem.separator())

        let quitItem = NSMenuItem(title: "Quit",
                                  action: #selector(quit),
                                  keyEquivalent: "")
        quitItem.target = self
        if let last = menu.items.last, !last.isSeparatorItem {
            menu.items.append(NSMenuItem.separator())
        }
        menu.items.append(quitItem)

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

    @objc private func removeUserDefaultsPath(_ sender: NSMenuItem) {
        let path = sender.title
        if let index = derivedDataPaths?.firstIndex(where: { $0 == path }) {
            derivedDataPaths?.remove(at: index)
        }
    }

    @objc private func addUserDefaultsPath(_ sender: NSMenuItem) {
        let path = sender.title
        derivedDataPaths?.append(path)
    }

    @objc private func selectDerivedData(_ sender: NSMenuItem) {
        let dialog = NSOpenPanel()
        dialog.canChooseDirectories = true
        dialog.canChooseFiles = false
        dialog.allowsMultipleSelection = false
        if dialog.runModal() == .OK, let newPath = dialog.url?.path {
            derivedDataPaths?.append(newPath)
        }
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

private extension URL {
    var pathAbbreviatingWithTilde: String {
        // find home directory path (more difficulty because we're sandboxed, so it's somewhere deep in our actual home dir)
        let sandboxedHomeDir = FileManager.default.homeDirectoryForCurrentUser
        let components = sandboxedHomeDir.pathComponents
        guard components.first == "/" else { return path }
        let homeDir = "/" + components.dropFirst().prefix(2).joined(separator: "/")

        // replace home dir in path with tilde for brevity and aesthetics
        guard path.hasPrefix(homeDir) else { return path }
        return "~" + path.dropFirst(homeDir.count)
    }
}
