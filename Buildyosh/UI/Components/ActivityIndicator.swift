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

    func makeNSView(context: Context) -> NSProgressIndicator {
        let progressIndicator = NSProgressIndicator()
        progressIndicator.isIndeterminate = false
        return progressIndicator
    }

    func updateNSView(_ nsView: NSProgressIndicator, context: Context) {
        nsView.doubleValue = value * .maxPercent
    }
}

private extension Double {
    static let maxPercent = 100.0
}
