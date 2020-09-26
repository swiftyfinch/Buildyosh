//
//  Images.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 28.08.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

extension Image {
    static var clock: some View {
        Image("clock.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 16, height: 16)
    }

    static var tray: some View {
        Image("tray.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 18, height: 18)
    }

    static var buildCount: some View {
        Image("hammer")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 16, height: 16)
    }

    static var success: some View {
        Image("checkmark")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 17, height: 17)
    }

    static var question: some View {
        Image("questionmark.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 19, height: 19)
            .foregroundColor(.aboutOpenButton)
    }

    static var questionFill: some View {
        Image("questionmark.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 19, height: 19)
            .foregroundColor(.aboutOpenButton)
    }

    static var close: some View {
        Image("multiply.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 19, height: 19)
    }

    static var twitter: some View {
        Image("twitter")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 18, height: 18)
    }

    static var blog: some View {
        Image("book")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 18, height: 18)
    }
}
