//
//  ButtonModifier.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 29.09.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct ButtonModifier: ViewModifier {
    let color: Color
    let cornerRadius: CGFloat

    init(color: Color = Color(white: 0.14),
         cornerRadius: CGFloat = 8) {
        self.color = color
        self.cornerRadius = cornerRadius
    }

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, 6.5)
            .padding(.vertical, 6.5)
            .background(color)
            .cornerRadius(cornerRadius)
            .padding(.horizontal, 1.5)
            .padding(.vertical, 1.5)
            .background(Color(white: 0.12))
            .cornerRadius(cornerRadius)
            .shadow(radius: 0.5)
    }
}
