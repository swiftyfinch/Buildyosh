//
//  ButtonModifier.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 29.09.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    let cornerRadius: CGFloat

    init(cornerRadius: CGFloat = 8) {
        self.cornerRadius = cornerRadius
    }

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 6.5)
            .padding(.vertical, 6.5)
            .background(Color.roundBackground)
            .cornerRadius(cornerRadius)
            .padding(.horizontal, 1.5)
            .padding(.vertical, 1.5)
            .background(Color.roundBackgroundBorder)
            .cornerRadius(cornerRadius)
            .shadow(radius: 0.5)
    }
}
