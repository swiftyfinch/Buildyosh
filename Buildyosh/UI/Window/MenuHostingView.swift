//
//  MenuHostingView.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 26.09.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import SwiftUI

final class MenuHostingView<Content: View>: NSHostingView<Content> {
    override func viewDidMoveToWindow() {
        window?.becomeKey()
    }
}
