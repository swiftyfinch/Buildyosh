//
//  AboutView.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 08.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI
import AVFoundation

struct AboutView: View {
    @EnvironmentObject private var store: Store<MainState, Action>

    var body: some View {
        VStack(spacing: 4) {
            Button(action: {
                let utterance = AVSpeechUtterance(string: "Buildyosh")
                utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
                utterance.rate = 0.4

                let synthesizer = AVSpeechSynthesizer()
                synthesizer.speak(utterance)
            }) {
                HStack(spacing: 5) {
                    Image("gear")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 17, height: 17)
                        .foregroundColor(.aboutAppIcon)
                    Text("Buildyosh")
                        .font(.aboutTitle)
                        .foregroundColor(.aboutTitle)
                    Text("v\(store.appVersion)")
                        .font(.aboutVersion)
                        .foregroundColor(.aboutVersion)
                }
                .modifier(RoundedEdge())
            }
            .buttonStyle(PlainButtonStyle())

            VStack(spacing: 0) {
                HStack(spacing: 2) {
                    Text("Log")
                        .foregroundColor(.aboutBody)
                    Image.clock
                        .foregroundColor(.clockIcon)
                    Text("of each build")
                        .foregroundColor(.aboutBody)
                }.font(.aboutBody)
                HStack(spacing: 2) {
                    Text("Find out average")
                        .foregroundColor(.aboutBody)
                    Image.clock
                        .foregroundColor(.averageClockIcon)
                    Text("per day")
                        .foregroundColor(.aboutBody)
                }.font(.aboutBody)
            }
            .modifier(RoundedEdge())

            HStack(spacing: 4) {
                VStack(spacing: 0) {
                    HStack(spacing: 2) {
                        Text("Tap")
                            .foregroundColor(.aboutBody)
                        Text("to change mode:")
                            .foregroundColor(.aboutBody)
                    }.font(.aboutBody)
                    HStack(spacing: 3) {
                        Text("Builds")
                            .foregroundColor(.aboutBody)
                        Text("count")
                            .foregroundColor(.aboutBody)
                        Image.buildCount
                            .foregroundColor(.buildCount)
                    }.font(.aboutBody)
                    HStack(spacing: 2) {
                        Text("Success")
                            .foregroundColor(.aboutBody)
                        Text("rate")
                            .foregroundColor(.aboutBody)
                        Image.success
                            .foregroundColor(.successRate)
                    }.font(.aboutBody)
                }
                .modifier(RoundedEdge())

                VStack(alignment: .leading, spacing: 4) {
                    Button(action: {
                        let url = URL(string: "https://twitter.com/swiftyfinch")!
                        NSWorkspace.shared.open(url)
                    }) {
                        Image.twitter
                            .frame(width: 16, height: 16)
                            .modifier(ButtonModifier())
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        let url = URL(string: "https://swiftyfinch.github.io/en#buildyosh")!
                        NSWorkspace.shared.open(url)
                    }) {
                        Image.blog
                            .frame(width: 16, height: 16)
                            .modifier(ButtonModifier())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
        }
    }
}
