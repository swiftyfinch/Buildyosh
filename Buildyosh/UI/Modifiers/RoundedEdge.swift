//
//  RoundedEdge.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 08.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct RoundedEdge: ViewModifier {

    let width: CGFloat
    let height: CGFloat
    let color: Color
    let cornerRadius: CGFloat

    init(width: CGFloat = 8,
         height: CGFloat = 8,
         color: Color = .roundBackground,
         cornerRadius: CGFloat = 8) {
        self.width = width
        self.height = height
        self.color = color
        self.cornerRadius = cornerRadius
    }

    func body(content: Content) -> some View {
        content
            .padding(.horizontal, width)
            .padding(.vertical, height)
            .background(color)
            .cornerRadius(cornerRadius)
            .shadow(radius: 0.5)
    }
}
