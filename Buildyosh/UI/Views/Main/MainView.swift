//
//  MainView.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 09.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI
import GBDeviceInfo

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
            .environment(\.colorScheme, .dark)

            ProjectsSection(projects: store.state.projects,
                            duration: store.state.duration)

            if store.state.isExpanded {
                makeInfo()
                    .modifier(RoundedEdge(horizontalPadding: 9, verticalPadding: 4.5))
                    .padding(.top, -1)
                    .frame(width: store.state.size.width - 60)
            }
        }
    }

    private func makeInfo() -> some View {
        let hw = store.state.hardware
        return VStack {
            if let model = hw.model, let year = hw.year {
                HStack(spacing: 3) {
                    Image.computer
                        .padding(.trailing, 1)
                        .foregroundColor(.project)
                    Text("\(model)")
                        .foregroundColor(.project)
                    Text(year)
                        .foregroundColor(.buildCount)
                }
                .padding(.bottom, -7)
            }

            if let processorSpeed = hw.processorSpeed, let processorName = hw.processorName {
                HStack(spacing: 3) {
                    Text("\(processorName)")
                        .foregroundColor(.project)
                    Text(processorSpeed)
                        .foregroundColor(.buildCount)
                }
            }

            if let memory = hw.memory {
                HStack(spacing: 3) {
                    Text("Memory")
                        .foregroundColor(.project)
                    Text(memory)
                        .foregroundColor(.buildCount)
                }
            }
        }
        .font(.font(size: 12))
    }
}
