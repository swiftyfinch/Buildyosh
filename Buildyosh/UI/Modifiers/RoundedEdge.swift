//
//  RoundedEdge.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 08.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct RoundedEdge: ViewModifier {
    let color: Color
    let cornerRadius: CGFloat
    let horizontalPadding: CGFloat
    let verticalPadding: CGFloat

    init(color: Color = .roundBackground,
         cornerRadius: CGFloat = 8,
         horizontalPadding: CGFloat = 6.5,
         verticalPadding: CGFloat = 6.5) {
        self.color = color
        self.cornerRadius = cornerRadius
        self.horizontalPadding = horizontalPadding
        self.verticalPadding = verticalPadding
    }

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, horizontalPadding)
            .padding(.vertical, verticalPadding)
            .background(color)
            .cornerRadius(cornerRadius)
            .padding(.horizontal, 1.5)
            .padding(.vertical, 1.5)
            .background(Color.roundBackgroundBorder)
            .cornerRadius(cornerRadius)
            .shadow(radius: 0.5)
    }
}
