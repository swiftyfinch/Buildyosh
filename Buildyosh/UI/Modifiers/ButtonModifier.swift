//
//  ButtonModifier.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 29.09.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat
    let cornerRadius: CGFloat
    let disabled: Bool

    init(horizontalPadding: CGFloat = 6.5,
         verticalPadding: CGFloat = 6.5,
         cornerRadius: CGFloat = 8,
         disabled: Bool = false) {
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
        self.cornerRadius = cornerRadius
        self.disabled = disabled
    }

    func body(content: Content) -> some View {
        if disabled {
            return AnyView(content)
        } else {
            return AnyView(
                content
                    .padding(.horizontal, horizontalPadding)
                    .padding(.vertical, verticalPadding)
                    .background(Color.roundBackground)
                    .cornerRadius(cornerRadius)
                    .padding(.horizontal, 1.5)
                    .padding(.vertical, 1.5)
                    .background(Color.roundBackgroundBorder)
                    .cornerRadius(cornerRadius)
                    .shadow(radius: 0.5)
            )
        }
    }
}
