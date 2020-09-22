//
//  Reducer.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 20.09.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

private extension CGFloat {
    static let width: CGFloat = 280
    static let loaderHeight: CGFloat = 60
    static let minAboutHeight: CGFloat = 180
}

final class Reducer {
    func reduce(state: MainState, action: Action) -> MainState {
        var state = state
        switch action {
        case .beginLoading:
            state.progress = 0
            state.isLoaded = false
            state = updateSize(state: state)
        case .changeProgress(let progress):
            state.progress = progress
        case .endLoading:
            state.isLoaded = true
            state = updateSize(state: state)
        case .changePeriodType(let periodType):
            state.periodType = periodType
            state = updateContent(state: state)
            state = updateSize(state: state)
        case .updatePeriods(let periods):
            state.periods = periods
            state = updateContent(state: state)
            state = updateSize(state: state)
        case .changeMode:
            if let newMode = MainState.Mode(rawValue: state.mode.rawValue + 1) {
                state.mode = newMode
            } else {
                state.mode = MainState.Mode.allCases[0]
            }
        case .toggleAbout:
            state.isAboutShown.toggle()
            state = updateSize(state: state)
        }
        return state
    }

    private func updateContent(state: MainState) -> MainState {
        var state = state
        let builder = ProjectsBuilder()
        let info = builder.build(fromPeriods: state.periods,
                                 withPeriodType: state.periodType)
        state.projects = info.projects
        state.duration = info.duration
        return state
    }

    private func updateSize(state: MainState) -> MainState {
        var state = state
        var newHeight: CGFloat
        if !state.isLoaded && state.projects.isEmpty {
            newHeight = .loaderHeight
        } else {
            let contentHeight = ProjectsSection.height(
                projects: state.projects,
                duration: state.duration
            )
            if state.isAboutShown {
                newHeight = .minAboutHeight
            } else {
                newHeight = contentHeight
            }
        }
        state.size = CGSize(width: .width, height: newHeight)
        return state
    }
}
