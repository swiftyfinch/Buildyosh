//
//  WindowManager.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 23.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import AppKit
import SwiftUI

final class WindowManager<Content: View> {

    private let rootView: Content
    private let model: Model

    private var statusBarItem: NSStatusItem?
    private var window: NSWindow?
    private var currentEventHandler: Any?

    init(rootView: Content, model: Model) {
        self.rootView = rootView
        self.model = model
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

        let image = NSImage(named: "gear")
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
        window.backgroundColor = .clear
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
        model.isWindowShown = true
        updateWindowPosition()

        NotificationCenter.default.addObserver(
            forName: NSWindow.didChangeOcclusionStateNotification,
            object: nil,
            queue: .main
        ) { [weak self] notification in
            guard let window = notification.object as? NSWindow, window.isStatusBar else { return }

            let app = NSApplication.shared
            let yPosition: CGFloat
            if app.isStatusBarHidden {
                yPosition = app.statusBarShownPosition
            } else {
                yPosition = app.statusBarHiddenPosition
            }
            self?.updateWindowPosition(yPosition: yPosition, animated: true)
        }

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

        model.isWindowShown = false
    }

    private func updateWindowPosition(yPosition: CGFloat? = nil, animated: Bool = false) {
        guard
            let statusBarItemFrame = statusBarItem?.button?.window?.frame,
            let windowBounds = window?.contentView?.bounds
        else { return }

        var point = statusBarItemFrame.origin
        point.x -= (windowBounds.width - statusBarItemFrame.width) / 2
        yPosition.map { point.y = $0 }
        point.y += model.isStatusBarHidden ? 44 : 0

        guard animated else {
            window?.setFrameTopLeftPoint(point)
            return
        }
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.2
            var frame = window!.frame
            frame.origin = point
            frame.origin.y -= frame.height
            window?.animator().setFrame(frame, display: true, animate: true)
        }
    }
}
