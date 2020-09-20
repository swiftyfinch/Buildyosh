//
//  ContentView.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 25.06.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var store: Store<State, Action>

    var body: some View {
        return VStack {
            if !store.state.isLoaded {
                Spacer()
                ActivityIndicator(value: store.state.progress)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, -5)
                Text(store.state.progress.outputPercent())
                Spacer()
            } else {
                VStack {
                    if store.state.isAboutShown {
                        AboutView()
                    } else {
                        MainView()
                    }

                    HStack {
                        Spacer()
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
                        .padding(.trailing, 3)
                        .foregroundColor(.aboutOpenButton)
                    }
                    .padding(.bottom, 16)
                    .frame(height: 0)
                }
            }
        }
        .frame(width: store.state.size.width,
               height: store.state.size.height)
    }
}
