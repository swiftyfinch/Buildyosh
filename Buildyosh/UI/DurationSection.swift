//
//  DurationSection.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 26.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct DurationSection: View {

    struct Model {
        let totalDuration: String
        let perDayDuration: String
    }

    let duration: Model

    var body: some View {
        HStack(spacing: 2) {
            Image.clock
                .foregroundColor(.averageClockIcon)
            Text(duration.perDayDuration)
                .font(.time)
                .foregroundColor(.averageClockText)
            Spacer().frame(width: 2)
            Image.clock
                .foregroundColor(.clockIcon)
            Text(duration.totalDuration)
                .font(.time)
                .foregroundColor(.clockText)
        }
        .modifier(RoundedEdge())
    }
}
