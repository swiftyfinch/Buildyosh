//
//  View+Hidden.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 08.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

extension View {

    func changeVisibility(toHidden hidden: Bool) -> some View {
        modifier(HiddenModifier(isHidden: hidden))
    }
}

struct HiddenModifier: ViewModifier {

    let isHidden: Bool

    func body(content: Content) -> some View {
        Group {
            if isHidden {
                content.hidden()
            } else {
                content
            }
        }
    }
}
