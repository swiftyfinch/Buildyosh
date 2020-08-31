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

    private let projects: [ProjectSection.Model]
    private let needShowDuration: Bool
    private let duration: DurationSection.Model

    init(projects: [Project], duration: Duration) {
        self.projects = projects.map {
            return ProjectSection.Model(name: $0.name,
                                        totalDuration: $0.duration.outputDuration())
        }

        self.needShowDuration = duration.days > 1
        self.duration = DurationSection.Model(totalDuration: duration.total.outputDuration(),
                                              perDayDuration: duration.perDay.outputDuration())
    }

    var body: some View {
        VStack(spacing: 1) {
            VStack(spacing: 0) {
                if projects.isEmpty {
                    HStack(spacing: 5) {
                        Image.tray
                        Text("Empty")
                            .font(.project)
                    }
                    .foregroundColor(.project)
                    .frame(height: 15)
                } else {
                    ForEach(projects) { project in
                        ProjectSection(project: project)
                            .frame(height: 17.0)
                    }
                }
            }
            .modifier(RoundedEdge())

            DurationSection(duration: duration)
                .padding(.top, 4.0)
                .frame(height: needShowDuration ? nil : 0)
                .changeVisibility(toHidden: !needShowDuration)
        }
        .padding(.leading, 8)
        .padding(.trailing, 8)
    }

    static func height(projects: [Project], duration: Duration) -> CGFloat {
        let count = CGFloat(max(1, projects.count))
        let durationSection: CGFloat = duration.days > 1 ? 17 + 16 + 4 : 0
        return count * 17 + 16 + durationSection + 50
    }
}
