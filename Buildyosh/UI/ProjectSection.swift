//
//  ProjectSection.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 23.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct ProjectSection: View {

    struct Model: Identifiable {
        var id: String { name }
        
        let name: String
        let totalDuration: String
    }
    let project: Model

    var body: some View {
        HStack(spacing: 4) {
            Text(project.name)
                .font(.project)
                .foregroundColor(.project)
            Image.clock
                .foregroundColor(.clockIcon)
                .padding(.trailing, -2)
            Text(project.totalDuration)
                .font(.time)
                .foregroundColor(.clockText)
        }
    }
}
