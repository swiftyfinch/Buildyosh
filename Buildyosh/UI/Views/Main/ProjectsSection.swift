//
//  ProjectsSection.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 08.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

private extension Int {
    func output() -> String { String(self) }
    func outputSucceedRate() -> String { output() + "%" }
}

struct ProjectsSection: View {
    @EnvironmentObject private var store: Store<MainState, Action>

    private let projects: [ProjectSection.Model]
    private let duration: DurationSection.Model?

    init(projects: [Project], duration: Duration?) {
        self.projects = projects.map {
            return ProjectSection.Model(id: $0.id,
                                        name: $0.name,
                                        totalDuration: $0.duration.outputDuration(),
                                        buildCount: $0.count.output(),
                                        successRate: $0.successRate.outputSucceedRate())
        }

        self.duration = duration.map {
            DurationSection.Model(totalDuration: $0.total.outputDuration(),
                                  perDayDuration: $0.perDay.outputDuration(),
                                  totalBuildCount: $0.buildCount.output(),
                                  totalSuccessRate: $0.successRate.outputSucceedRate())
        }
    }

    var body: some View {
        VStack(spacing: 1) {
            Button {
                store.send(.changeMode)
            } label: {
                VStack(spacing: 4) {
                    VStack(spacing: 0) {
                        if projects.isEmpty {
                            HStack(spacing: 5) {
                                Image.tray
                                Text("Empty")
                                    .font(.emptyProject)
                            }
                            .foregroundColor(.project)
                            .frame(height: 17)
                        } else {
                            ForEach(projects) { project in
                                ProjectSection(project: project)
                                    .frame(height: 17.0)
                            }
                        }
                    }
                    .modifier(ButtonModifier())

                    if let duration = duration {
                        DurationSection(duration: duration)
                            .modifier(ButtonModifier())
                    }
                }
                .background(Color.black.opacity(0.01))
            }
            .buttonStyle(PlainButtonStyle())
            .frame(width: store.state.size.width - 60.0)
        }
    }

    static func height(projects: [Project],
                       needShowDuration: Bool) -> CGFloat {
        let count = CGFloat(max(1, projects.count))
        let durationSection: CGFloat = needShowDuration ? 17 + 16 + 4 : 0
        return count * 17 + 16 + durationSection + 40
    }
}
