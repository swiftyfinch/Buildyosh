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
                if !store.state.isLoaded {
                    ActivityIndicator(value: store.state.progress)
                        .padding(.leading, 20)
                        .padding(.trailing, 20)
                        .padding(.bottom, -5)
                    Text(store.state.progress.outputPercent())
                } else {
                    if store.state.isAboutShown {
                        AboutView()
                    } else {
                        MainView()
                    }
                }
                Spacer()
            }

            if store.state.isLoaded {
                GeometryReader { proxy in
                    Button(action: {
                        store.send(.toggleAbout)
                    }) {
                        if store.state.isAboutShown {
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
