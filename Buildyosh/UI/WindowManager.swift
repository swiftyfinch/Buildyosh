//
//  WindowManager.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 23.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import AppKit
import SwiftUI

final class WindowManager<Content> where Content: View {

    private let rootView: Content

    private var statusBarItem: NSStatusItem?
    private var window: NSWindow?
    private var currentEventHandler: Any?

    init(rootView: Content) {
        self.rootView = rootView
    }

    func buildAndPresent() {
        self.statusBarItem = buildStatusBarItem()
        self.window = buildWindow()

        showPopover()
        statusBarItem?.button?.isHighlighted = true
    }

    private func buildStatusBarItem() -> NSStatusItem {
        let statusBar = NSStatusBar.system
        let statusBarItem = statusBar.statusItem(withLength: NSStatusItem.variableLength)

        let image = NSImage(named: "statusBarIcon")
        image?.isTemplate = true
        statusBarItem.button?.image = image

        statusBarItem.button?.target = self
        statusBarItem.button?.action = #selector(statusBarButtonClicked(sender:))
        statusBarItem.button?.sendAction(on: [.leftMouseUp, .rightMouseUp])

        let statusBarMenu = NSMenu(title: "")
        let item = NSMenuItem(title: "Quit", action: #selector(quit), keyEquivalent: "")
        item.target = self
        statusBarMenu.addItem(item)
        statusBarItem.button?.menu = statusBarMenu

        return statusBarItem
    }

    private func buildWindow() -> NSWindow {
        let controller = NSHostingController(rootView: rootView)
        let window = NSWindow(contentViewController: controller)

        window.styleMask.remove(.titled)
        window.titleVisibility = .hidden
        window.titlebarAppearsTransparent = true
        window.styleMask.remove(.closable)
        window.styleMask.remove(.miniaturizable)
        window.styleMask.remove(.resizable)
        window.styleMask.insert(.borderless)

        window.contentView?.wantsLayer = true
        window.backgroundColor = NSColor.clear
        window.contentView?.layer?.masksToBounds = true
        window.contentView?.layer?.cornerRadius = 8.0
        window.contentView?.layer?.maskedCorners = [.layerMinXMaxYCorner,
                                                    .layerMaxXMaxYCorner]

        window.isMovable = false

        return window
    }

    @objc private func quit() {
        NSApplication.shared.terminate(self)
    }

    @objc private func statusBarButtonClicked(sender: NSStatusBarButton) {
        guard let event = NSApp.currentEvent else { return }

        if event.type == .rightMouseUp, let button = statusBarItem?.button {
            hidePopover(unhighlight: false)
            button.menu?.popUp(positioning: nil,
                               at: CGPoint(x: -1, y: button.bounds.maxY + 5),
                               in: button)
        } else if event.type == .leftMouseUp {
            if let window = window, window.isVisible {
                hidePopover()
            } else {
                showPopover()
                DispatchQueue.main.async {
                    self.statusBarItem?.button?.isHighlighted = true
                }
            }
        }
    }

    private func showPopover() {
        guard
            let statusBarItemFrame = statusBarItem?.button?.window?.frame,
            let windowBounds = window?.contentView?.bounds
        else { return }

        var point = statusBarItemFrame.origin
        point.x -= (windowBounds.width - statusBarItemFrame.width) / 2
        point.y += 22.0
        window?.setFrameTopLeftPoint(point)

        window?.makeKeyAndOrderFront(nil)
        NSApplication.shared.activate(ignoringOtherApps: true)

        currentEventHandler = NSEvent.addGlobalMonitorForEvents(
            matching: [.leftMouseDown, .rightMouseDown]
        ) { [weak self] event in
            self?.hidePopover()
        }
    }

    private func hidePopover(unhighlight: Bool = true) {
        window?.orderOut(self)

        if let eventHandler = currentEventHandler {
            NSEvent.removeMonitor(eventHandler)
            currentEventHandler = nil
        }

        if unhighlight {
            statusBarItem?.button?.isHighlighted = false
        }
    }
}
