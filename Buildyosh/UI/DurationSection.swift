//
//  DurationSection.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 26.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct DurationSection: View {

    private let totalDuration: Double
    private let perDayDuration: Double

    init(totalDuration: Double,
         perDayDuration: Double) {
        self.totalDuration = totalDuration
        self.perDayDuration = perDayDuration
    }

    var body: some View {
        HStack {
            Text("✈︎")
                .font(.system(size: .titleFontSize,
                              weight: .semibold,
                              design: .rounded))
            Text(totalDuration.outputDuration())
                .foregroundColor(.yellow)
                .padding(.leading, -3)
            Text("(" + perDayDuration.outputDuration() + ")")
                .foregroundColor(.orange)
                .padding(.leading, -3)
        }
    }
}

private extension Color {
    static let primary: Color = Color.blue
}

private extension CGFloat {
    static let titleFontSize: CGFloat = 14
}

private extension Double {
    func output() -> String { String(ceil(self)) }
}
