//
//  Reducer.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 20.09.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation
import Combine

private extension CGFloat {
    static let width: CGFloat = 280
    static let loaderHeight: CGFloat = 70
    static let minAboutHeight: CGFloat = 179
}

final class Reducer {
    private let verifyService = GumroadService()

    func reduce(state: inout MainState, action: Action) -> AnyPublisher<Action, Never>? {
        switch action {
        case .beginOnboarding:
            state.screen = .onboarding(.begin)
            state = updateSize(state: state)
        case .verifyKey(let key):
            state.screen = .onboarding(.loading)
            state = updateSize(state: state)
            return verifyService.verify(key: key)
        case .errorOnboarding(let message):
            state.screen = .onboarding(.error(message))
            state = updateSize(state: state)
        case .finishOnboarding:
            state.screen = .onboarding(.finish)
            state = updateSize(state: state)
        case .beginLoading where !state.projects.isEmpty:
            break // don't change screen
        case .beginLoading:
            state.progress = 0
            state.screen = .loading
            state = updateSize(state: state)
        case .changeProgress(let progress):
            state.progress = progress
        case .endLoading where state.screen == .loading:
            state.screen = .main
            state = updateSize(state: state)
        case .endLoading:
            break // don't change screen
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
            if state.screen == .main {
                state.screen = .about
            } else {
                state.screen = .main
            }
            state = updateSize(state: state)
        }
        return nil
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
        switch state.screen {
        case .loading:
            newHeight = .loaderHeight
        case .about:
            newHeight = .minAboutHeight
        case .onboarding:
            newHeight = 150
        case .main:
            let contentHeight = ProjectsSection.height(
                projects: state.projects,
                duration: state.duration
            )
            newHeight = contentHeight
        }
        state.size = CGSize(width: .width, height: newHeight)
        return state
    }
}
