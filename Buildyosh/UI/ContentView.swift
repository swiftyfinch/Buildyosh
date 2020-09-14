//
//  ContentView.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 25.06.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var model: Model

    var body: some View {
        VStack {
            if model.needShowLoader {
                Spacer()
                ActivityIndicator(value: $model.progress)
                    .padding(.leading, 20)
                    .padding(.trailing, 20)
                    .padding(.bottom, -5)
                Text(model.progress.outputPercent())
                Spacer()
            } else {
                VStack {
                    if model.isAboutShown {
                        AboutView()
                    } else {
                        MainView()
                    }

                    HStack {
                        Spacer()
                        Button(action: {
                            model.isAboutShown.toggle()
                        }) {
                            if model.isAboutShown {
                                Image.questionFill
                            } else {
                                Image.question
                            }
                        }
                        .buttonStyle(PlainButtonStyle())
                        .padding(.trailing, 3)
                        .padding(.bottom, 16)
                        .foregroundColor(.aboutOpenButton)
                    }
                    .frame(height: 0)
                }
            }
        }
        .frame(width: model.size.width, height: model.size.height)
    }
}
