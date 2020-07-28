//
//  ProjectSection.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 23.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct ProjectSection: View {

    private let project: Project
    
    init(project: Project) {
        self.project = project
    }

    var body: some View {
        HStack {
            Text(project.name)
                .font(.system(size: .titleFontSize,
                              weight: .semibold,
                              design: .rounded))
            Text(project.schemes.count.output())
                .foregroundColor(.gray)
                .padding(.leading, -3)
            Text(project.succeedRate.outputSucceedRate())
                .foregroundColor(.green)
                .padding(.leading, -3)
            Text(project.totalDuration.outputDuration())
                .foregroundColor(.yellow)
                .padding(.leading, -3)
        }
    }
}

private extension CGFloat {
    static let titleFontSize: CGFloat = 14
}

private extension Int {
    func output() -> String { String(self) }
    func outputSucceedRate() -> String { output() + "%" }
}
