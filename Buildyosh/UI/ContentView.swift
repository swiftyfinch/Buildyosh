//
//  ContentView.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 25.06.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: Store<MainState, Action>

    var body: some View {
        ZStack {
            GeometryReader { _ in
                Color.black.opacity(0.01)
            }

            VStack(spacing: 0) {
                Spacer()
                switch store.state.screen {
                case .loading:
                    ActivityIndicator(value: store.state.progress)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                case .main:
                    MainView()
                case .about:
                    AboutView()
                case .onboarding:
                    OnboardingView()
                }
                Spacer()
            }

            if store.state.screen == .main || store.state.screen == .about {
                GeometryReader { proxy in
                    if store.state.screen == .main {
                        Button(action: {
                            store.send(.toggleExpand)
                        }) {
                            if store.state.isExpanded {
                                Image.expandFill//.rotationEffect(.init(degrees: 180))
                            } else {
                                Image.expand
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .position(x: 12,
                                  y: proxy.size.height - 8)
                    }

                    Button(action: {
                        store.send(.toggleAbout)
                    }) {
                        if store.state.screen == .about {
                            Image.questionFill
                        } else {
                            Image.question
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    .position(x: proxy.size.width - 12,
                              y: proxy.size.height - 8)
                }
            }
        }
        .frame(width: store.state.size.width,
               height: store.state.size.height)
    }
}
