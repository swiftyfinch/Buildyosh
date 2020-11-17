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

    private static let expandedRowHeight: CGFloat = 39

    init(projects: [Project], duration: Duration?) {
        self.projects = projects.enumerated().map { index, value in
            return ProjectSection.Model(id: value.id,
                                        name: value.name,
                                        totalDuration: value.duration.outputDuration(),
                                        buildCount: value.count.output(),
                                        successRate: value.successRate.outputSucceedRate(),
                                        position: index)
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
            if projects.isEmpty {
                HStack(spacing: 5) {
                    Image.tray
                    Text("Empty")
                        .font(.emptyProject)
                }
                .foregroundColor(.project)
                .frame(height: 17)
                .modifier(ButtonModifier())
            } else if store.state.isExpanded {
                VStack(spacing: 4) {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(projects) { project in
                            ZStack(alignment: .bottom) {
                                VStack(alignment: .leading) {
                                    ProjectSection(project: project)
                                        .frame(height: Self.expandedRowHeight)
                                }

                                if project.position + 1 != projects.count {
                                    Color(white: 0.23)
                                        .frame(height: 1)
                                        .padding(.horizontal, -6)
                                        .shadow(radius: 0.5)
                                        .opacity(0.9)
                                }
                            }
//                            .background(Color.red)
                        }
                    }
                    .modifier(ButtonModifier(verticalPadding: 2))

                    if let duration = duration {
                        DurationSection(duration: duration)
                            .frame(height: Self.expandedRowHeight)
                            .modifier(ButtonModifier(verticalPadding: 2))
                    }
                }
                .background(Color.black.opacity(0.01))
                .frame(width: store.state.size.width - 60.0)
            } else {
                Button {
                    store.send(.changeMode)
                } label: {
                    VStack(spacing: 4) {
                        VStack(spacing: 0) {
                            ForEach(projects) { project in
                                ProjectSection(project: project)
                                    .frame(height: 17)
                            }
                        }
                        .modifier(ButtonModifier())

                        if let duration = duration {
                            DurationSection(duration: duration)
                                .frame(height: 17)
                                .modifier(ButtonModifier())
                        }
                    }
                    .background(Color.black.opacity(0.01))
                }
                .buttonStyle(PlainButtonStyle())
                .frame(width: store.state.size.width - 60.0)
            }
        }
    }

    static func height(projects: [Project],
                       needShowDuration: Bool,
                       expanded: Bool) -> CGFloat {
        let count = CGFloat(max(1, projects.count))
        let rowHeight: CGFloat = expanded && !projects.isEmpty ? expandedRowHeight : 17
        let rowsHeight: CGFloat = count * rowHeight
        let lineHeight: CGFloat = expanded && !projects.isEmpty ? 3 : 0
        let linesHeight = (count - 1) * lineHeight
        let topBottomPadding: CGFloat = expanded && !projects.isEmpty ? 7 : 16
        var durationSection: CGFloat = 0
        if needShowDuration {
            durationSection += rowHeight + 12
            durationSection += expanded ? -1 : 8
        }
        return rowsHeight + linesHeight + durationSection + 40 + topBottomPadding
    }
}

struct EmptyModifier: ViewModifier {
    func body(content: Content) -> some View { content }
}
