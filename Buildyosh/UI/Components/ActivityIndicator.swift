//
//  ActivityIndicator.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 23.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct ActivityIndicator: NSViewRepresentable {

    private(set) var value: Double
    private let style: NSProgressIndicator.Style

    init(value: Double = 0, style: NSProgressIndicator.Style = .bar) {
        self.value = value
        self.style = style
    }

    func makeNSView(context: Context) -> NSProgressIndicator {
        let progressIndicator = NSProgressIndicator()
        progressIndicator.style = style
        if style == .bar {
            progressIndicator.isIndeterminate = false
        } else {
            progressIndicator.controlSize = .small
            progressIndicator.startAnimation(nil)
        }
        return progressIndicator
    }

    func updateNSView(_ nsView: NSProgressIndicator, context: Context) {
        nsView.doubleValue = value * .maxPercent
    }
}

private extension Double {
    static let maxPercent = 100.0
}
