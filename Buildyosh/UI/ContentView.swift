//
//  ContentView.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 25.06.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct ContentView: View {

    @EnvironmentObject private var manager: XcodeLogAsyncParser
    @EnvironmentObject private var dataSource: ProjectsDataSource
    @EnvironmentObject private var entryPoint: EntryPoint

    var body: some View {
        VStack {
            if !manager.isLoaded && dataSource.projects.isEmpty {
                Spacer()
                ActivityIndicator(value: $manager.progress)
                    .padding(.leading, 20.0)
                    .padding(.trailing, 20.0)
                    .padding(.bottom, -5.0)
                Text(manager.progress.outputPercent())
                Spacer()
            } else {
                Spacer()
                VStack {
                    if dataSource.projects.isEmpty {
                        Text("Empty")
                            .font(.system(size: 14.0, weight: .semibold, design: .rounded))
                    } else {
                        ForEach(dataSource.projects) { project in
                            ProjectSection(project: project)
                                .frame(height: 17.0)
                                .padding(.leading, 8)
                                .padding(.trailing, 8)
                        }
                        if (dataSource.duration?.days ?? 0) > 1 {
                            dataSource.duration.map {
                                DurationSection(totalDuration: $0.total, perDayDuration: $0.perDay)
                            }
                        }
                    }
                }
                Spacer()
                HStack {
                    Picker(selection: $dataSource.filterType, label: Text("")) {
                        Text("Today").tag(0)
                        Text("Yesterday").tag(1)
                        Text("Week").tag(2)
                        Text("All").tag(3)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.leading, -4.0)
                    .padding(.trailing, 4)
                    .opacity(0.7)
                }
                .frame(height: 20.0)
                .padding(.bottom, 5.0)
            }
        }
        .frame(width: .width, height: height(), alignment: .bottom)
        .background(Color(red: 0.2, green: 0.2, blue: 0.2))
    }

    private func height() -> CGFloat {
        if !manager.isLoaded && dataSource.projects.isEmpty {
            return 60.0
        } else {
            var count = CGFloat(max(1, dataSource.projects.count))
            if (dataSource.duration?.days ?? 0) > 1 { count += 1 }
            return 50.0 + count * 17.0
        }
    }
}

private extension CGFloat {
    static let width: CGFloat = 280.0
}
