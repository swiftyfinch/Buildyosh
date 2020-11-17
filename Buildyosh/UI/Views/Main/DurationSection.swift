//
//  DurationSection.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 26.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct DurationSection: View {
    @EnvironmentObject private var store: Store<MainState, Action>

    struct Model {
        let totalDuration: String
        let perDayDuration: String
        let totalBuildCount: String
        let totalSuccessRate: String
    }

    let duration: Model

    var body: some View {
        HStack(spacing: 0) {
            if store.state.isExpanded {
                makeExpandedBody()
            } else {
                makeNotExpandedBody()
            }
        }
    }

    private func makeNotExpandedBody() -> some View {
        HStack(spacing: 2) {
            switch store.state.mode {
            case .time:
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
            case .count, .success:
                Image.buildCount
                    .foregroundColor(.buildCount)
                Text(duration.totalBuildCount)
                    .font(.time)
                    .foregroundColor(.buildCount)
                Spacer().frame(width: 2)
                Image.success
                    .foregroundColor(.successRate)
                Text(duration.totalSuccessRate)
                    .font(.time)
                    .foregroundColor(.successRate)
            }
        }
    }

    private func makeExpandedBody() -> some View {
        VStack(spacing: 0) {
            HStack(spacing: 2) {
                Image.buildCount
                    .foregroundColor(.buildCount)
                Text(duration.totalBuildCount)
                    .font(.time)
                    .foregroundColor(.buildCount)
                Spacer().frame(width: 2)
                Image.success
                    .foregroundColor(.successRate)
                Text(duration.totalSuccessRate)
                    .font(.time)
                    .foregroundColor(.successRate)
            }

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
        }
    }
}
