//
//  OnboardingView.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 27.09.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct OnboardingView: View {
    @EnvironmentObject private var store: Store<MainState, Action>

    @State private var hideError = false

    var body: some View {
        VStack(spacing: 4) {
            ApplicationHeader(appVersion: store.appVersion)

            switch store.state.screen {
            case .onboarding(let state):
                if case .error(let message) = state, !hideError {
                    Button {
                        hideError = true
                    } label: {
                        Text(message)
                            .foregroundColor(.averageClockIcon)
                            .font(.aboutBody)
                            .multilineTextAlignment(.center)
                            .modifier(ButtonModifier())
                    }
                    .buttonStyle(PlainButtonStyle())
                } else {
                    Text("Hello! Copy your licence key and tap the button.")
                        .foregroundColor(.aboutBody)
                        .font(.aboutBody)
                        .multilineTextAlignment(.center)
                        .modifier(RoundedEdge())
                }
            default:
                EmptyView()
            }

            VStack {
                switch store.state.screen {
                case .onboarding(let state):
                    switch state {
                    case .begin:
                        Button {
                            guard let key = NSPasteboard.general.pasteboardItems?.first?.string(forType: .string) else {
                                // Show error
                                return
                            }
                            hideError = false
                            store.send(.verifyKey(key))
                        } label: {
                            Text("Verify")
                                .foregroundColor(.aboutTitle)
                                .font(.project)
                                .frame(width: 90, height: 16)
                                .modifier(ButtonModifier())
                        }
                        .buttonStyle(PlainButtonStyle())
                    case .loading:
                        ActivityIndicator(style: .spinning)
                            .frame(width: 90, height: 16)
                            .modifier(RoundedEdge())
                    case .error:
                        VStack(spacing: 4) {
                            HStack(spacing: 4) {
                                Button {
                                    hideError = false
                                    if let key = KeychainService().getKey() {
                                        return store.send(.verifyKey(key))
                                    }

                                    if let key = NSPasteboard.general.pasteboardItems?.first?.string(forType: .string) {
                                        return store.send(.verifyKey(key))
                                    }

                                    log(error: "Can't find any licence key or text from pasterboard.")
                                } label: {
                                    Text("Try again")
                                        .foregroundColor(.aboutTitle)
                                        .font(.project)
                                        .frame(width: 70, height: 16)
                                        .modifier(ButtonModifier())
                                }
                                .buttonStyle(PlainButtonStyle())

                                Button(action: {
                                    KeychainService().removeKey()
                                    store.send(.beginOnboarding)
                                }) {
                                    HStack(spacing: 5) {
                                        Text("Reset")
                                            .frame(width: 50, height: 16)
                                            .font(.aboutButton)
                                            .foregroundColor(.aboutBody)
                                    }
                                    .frame(height: 16)
                                    .modifier(ButtonModifier())
                                }
                                .buttonStyle(PlainButtonStyle())

                                Button(action: {
                                    let url = URL(string: "https://twitter.com/swiftyfinch")!
                                    NSWorkspace.shared.open(url)
                                }) {
                                    Image.twitter
                                        .frame(width: 16, height: 16)
                                        .modifier(ButtonModifier())
                                }
                                .buttonStyle(PlainButtonStyle())
                            }
                        }
                    case .finish:
                        Text("Success")
                            .foregroundColor(.successRate)
                            .font(.project)
                            .frame(width: 90, height: 16)
                            .modifier(RoundedEdge())
                    }
                default:
                    EmptyView()
                }
            }
        }
        .padding(.horizontal, 30)
        .frame(width: store.state.size.width,
               height: store.state.size.height)
    }
}
