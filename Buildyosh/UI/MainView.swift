//
//  MainView.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 09.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct MainView: View {

    @EnvironmentObject private var model: Model
    @EnvironmentObject private var dataSource: ProjectsDataSource

    var body: some View {
        VStack(spacing: 5) {
            Spacer().frame(height: 10)
            HStack {
                Picker(selection: $dataSource.filterType, label: EmptyView()) {
                    Text("Today").tag(0)
                    Text("Yday").tag(1)
                    Text("Week").tag(2)
                    Text("All").tag(3)
                }
                .font(.time)
                .pickerStyle(SegmentedPickerStyle())
            }
            .frame(width: 100)
            .frame(height: 20.0)

            ProjectsSection(projects: model.projects,
                            duration: model.duration)
            .frame(width: 220)
            Spacer()
        }
    }
}
