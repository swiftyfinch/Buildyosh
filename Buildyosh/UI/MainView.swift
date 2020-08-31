//
//  MainView.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 09.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct MainView: View {

    @EnvironmentObject private var dataSource: ProjectsDataSource

    var body: some View {
        VStack(spacing: 5) {
            Spacer()
            HStack {
                Image.calendar
                    .padding(.trailing, -5)
                    .foregroundColor(.periodIcon)
                Picker(selection: $dataSource.filterType, label: EmptyView()) {
                    Text("Today").tag(0)
                    Text("Yday").tag(1)
                    Text("Week").tag(2)
                    Text("All").tag(3)
                }
                .font(.time)
                .foregroundColor(.periodPicker)
                .pickerStyle(PopUpButtonPickerStyle())
            }
            .frame(width: 100)
            .frame(height: 20.0)

            ProjectsSection(projects: dataSource.projects,
                            duration: dataSource.duration)
            .frame(width: 220)
            Spacer()
        }
    }
}
