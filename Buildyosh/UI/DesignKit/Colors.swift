//
//  Colors.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 29.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

extension Color {
    @AdaptiveColor(light: Color(hex: 0xeeeeee).opacity(0.95),
                   dark: Color(white: 0.2).opacity(0.95))
    static var window: Color

    // MARK: - Period

    @AdaptiveColor(light: .init(white: 0.3), dark: .white)
    static var periodPicker: Color

    @AdaptiveColor(light: .init(white: 0.3), dark: .white)
    static var periodIcon: Color

    // MARK: - Sections

    @AdaptiveColor(light: .init(white: 1), dark: .init(white: 0.16))
    static var roundBackground: Color

    @AdaptiveColor(light: .init(white: 0.3), dark: .white)
    static var project: Color

    @AdaptiveColor(light: Color(hex: 0xf39f18))
    static var clockIcon: Color

    @AdaptiveColor(light: .clockIcon)
    static var clockText: Color

    @AdaptiveColor(light: .init(white: 0.7))
    static var buildCount: Color

    @AdaptiveColor(light: Color(hex: 0x58a32a))
    static var successRate: Color

    @AdaptiveColor(light: Color(hex: 0xef7b5a))
    static var averageClockIcon: Color

    @AdaptiveColor(light: .averageClockIcon)
    static var averageClockText: Color

    // MARK: - About

    @AdaptiveColor(light: .init(white: 0.2), dark: .init(white: 0.8))
    static var aboutOpenButton: Color

    @AdaptiveColor(light: .project, dark: .white)
    static var aboutAppIcon: Color

    @AdaptiveColor(light: .project, dark: .white)
    static var aboutTitle: Color

    @AdaptiveColor(light: .project, dark: Color(white: 0.9))
    static var aboutVersion: Color

    @AdaptiveColor(light: .project, dark: .white)
    static var aboutBody: Color

    @AdaptiveColor(light: Color(hex: 0x1cB8EB))
    static var aboutTwitter: Color
}

@propertyWrapper struct AdaptiveColor {
    private let light: Color
    private let dark: Color

    init(light: Color, dark: Color? = nil) {
        self.light = light
        self.dark = dark ?? light
    }

    var wrappedValue: Color {
        NSApp.effectiveAppearance.name == .darkAqua ? dark : light
    }
}
