//
//  AboutView.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 08.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

struct AboutView: View {

    private let appVersion = Bundle.main.object(forInfoDictionaryKey: "CFBundleShortVersionString") as! String

    var body: some View {
        VStack {
            Spacer()
            VStack(spacing: 4) {
                HStack(spacing: 5) {
                    Image("gear")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 17, height: 17)
                        .foregroundColor(.aboutAppIcon)
                    Text("Buildyosh")
                        .font(.aboutTitle)
                        .foregroundColor(.aboutTitle)
                    Text("v\(appVersion)")
                        .font(.aboutVersion)
                        .foregroundColor(.aboutVersion)
                }
                .modifier(RoundedEdge())

                VStack(spacing: 0) {
                    HStack(spacing: 3) {
                        Text("Logs")
                            .foregroundColor(.aboutBody)
                        Image.clock
                            .foregroundColor(.clockIcon)
                        Text("of each build")
                            .foregroundColor(.aboutBody)
                    }.font(.aboutBody)
                    HStack(spacing: 3) {
                        Text("Find out average")
                            .foregroundColor(.aboutBody)
                        Image.clock
                            .foregroundColor(.averageClockIcon)
                        Text("per day")
                            .foregroundColor(.aboutBody)
                    }.font(.aboutBody)
                }
                .modifier(RoundedEdge())

                HStack(spacing: 3) {
                    Button(action: {
                        let url = URL(string: "https://swiftyfinch.github.io/en#buildyosh")!
                        NSWorkspace.shared.open(url)
                    }) {
                        HStack(spacing: 2) {
                            Text("📚")
                                .font(.aboutBlog)
                            Text("Blog")
                                .font(.aboutBody)
                        }
                        .frame(height: 16)
                        .foregroundColor(.aboutBody)
                        .modifier(RoundedEdge())
                    }
                    .buttonStyle(PlainButtonStyle())

                    Button(action: {
                        let url = URL(string: "https://twitter.com/swiftyfinch")!
                        NSWorkspace.shared.open(url)
                    }) {
                        HStack {
                            Image("twitter")
                                .resizable()
                                .frame(width: 16, height: 16)
                                .aspectRatio(contentMode: .fit)
                                .foregroundColor(.aboutTwitter)
                                .padding(.trailing, -4)
                            Text("Feedback")
                                .font(.aboutBody)
                        }
                        .foregroundColor(.aboutBody)
                        .modifier(RoundedEdge())
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            Spacer()
        }
    }
}
