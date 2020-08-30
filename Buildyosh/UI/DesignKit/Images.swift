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

    static var calendar: some View {
        Image("calendar")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 22, height: 20)
    }

    static var question: some View {
        Image("questionmark.circle")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 19, height: 19)
    }

    static var questionFill: some View {
        Image("questionmark.circle.fill")
            .resizable()
            .aspectRatio(contentMode: .fit)
            .frame(width: 19, height: 19)
    }
}
