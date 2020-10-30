//
//  MainView.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 09.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct MainView: View {
    @EnvironmentObject private var store: Store<MainState, Action>

    var body: some View {
        VStack(spacing: 5) {
            Picker(selection: .init(get: {
                store.state.periodType
            }, set: { periodType in
                store.send(.changePeriodType(periodType))
            }), label: EmptyView()) {
                Text("Today").tag(0)
                Text("Yday").tag(1)
                Text("Week").tag(2)
                Text("All").tag(3)
            }
            .pickerStyle(SegmentedPickerStyle())
            .opacity(0.8)
            .frame(width: 100, height: 20)

            ProjectsSection(projects: store.state.projects,
                            duration: store.state.duration)
        }
    }
}
