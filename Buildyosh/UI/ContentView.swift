//
//  ContentView.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 25.06.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

private extension CGFloat {
    static let width: CGFloat = 260
    static let loaderHeight: CGFloat = 60
    static let minAboutHeight: CGFloat = 140
}

struct ContentView: View {
    @EnvironmentObject private var model: Model
    @EnvironmentObject private var manager: XcodeLogAsyncParser
    @EnvironmentObject private var dataSource: ProjectsDataSource
    @EnvironmentObject private var entryPoint: EntryPoint

    @State private var isAboutShown = false
    private var needShowLoader: Bool {
        !manager.isLoaded && dataSource.projects.isEmpty
    }

    var body: some View {
        VStack {
            if model.isStatusBarHidden {
                Spacer().frame(height: 44)
            }

            if needShowLoader {
                Spacer()
                ActivityIndicator(value: $manager.progress)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, -5)
                Text(manager.progress.outputPercent())
                Spacer()
            } else {
                VStack {
                    if isAboutShown {
                        AboutView()
                    } else {
                        MainView()
                    }

                    HStack {
                        Spacer()
                        Button(action: {
                            self.isAboutShown.toggle()
                        }) {
                            if isAboutShown {
                                Image.questionFill
                            } else {
                                Image.question
                            }
                        }
                        .foregroundColor(.aboutOpenButton)
                        .buttonStyle(PlainButtonStyle())
                        .padding(.trailing, 3)
                        .padding(.bottom, 27)
                    }.frame(height: 0)
                }
            }
        }
        .frame(width: .width, height: height())
        .background(Color.window)
        .changeVisibility(toHidden: !model.isWindowShown)
    }

    private func height() -> CGFloat {
        if !manager.isLoaded && dataSource.projects.isEmpty {
            return .loaderHeight
        } else {
            var contentHeight = ProjectsSection.height(
                projects: dataSource.projects,
                duration: dataSource.duration
            )
            contentHeight += model.isStatusBarHidden ? 44 : 0
            if isAboutShown {
                return max(contentHeight, .minAboutHeight)
            } else {
                return contentHeight
            }
        }
    }
}
