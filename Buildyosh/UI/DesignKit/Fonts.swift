//
//  Fonts.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 08.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

extension Font {

    static func font(size: CGFloat) -> Font {
        .system(size: size, weight: .semibold, design: .rounded)
    }

    static let calendar: Font = .font(size: 18)

    static let aboutButton: Font = .font(size: 16)
    static let aboutTitle: Font = .font(size: 17)
    static let aboutVersion: Font = .system(size: 13, weight: .bold, design: .rounded)
    static let aboutBody: Font = .font(size: 14)
    static let aboutBlog: Font = .font(size: 16)

    static let project: Font = .font(size: 15)
    static let emptyProject: Font = .font(size: 14)
    static let time: Font = .font(size: 13)
}
