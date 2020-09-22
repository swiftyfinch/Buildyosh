//
//  ProjectSection.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 23.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct ProjectSection: View {
    @EnvironmentObject private var store: Store<MainState, Action>

    struct Model: Identifiable {
        var id: String { name }
        
        let name: String
        let totalDuration: String
        let buildCount: String
        let successRate: String
    }
    let project: Model

    var body: some View {
        HStack(spacing: 4) {
            Text(project.name)
                .font(.project)
                .foregroundColor(.project)

            switch store.state.mode {
            case .time:
                Image.clock
                    .foregroundColor(.clockIcon)
                    .padding(.trailing, -2)
                Text(project.totalDuration)
                    .font(.time)
                    .foregroundColor(.clockText)
            case .count:
                Image.buildCount
                    .foregroundColor(.buildCount)
                    .padding(.trailing, -2)
                Text(project.buildCount)
                    .font(.time)
                    .foregroundColor(.buildCount)
            case .success:
                Image.success
                    .foregroundColor(.successRate)
                    .padding(.trailing, -2)
                Text(project.successRate)
                    .font(.time)
                    .foregroundColor(.successRate)
            }
        }
    }
}
