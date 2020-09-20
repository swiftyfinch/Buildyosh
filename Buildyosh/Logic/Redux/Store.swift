//
//  Store.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 20.09.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Combine

final class Store<State, Action>: ObservableObject {
    @Published private(set) var state: State

    typealias Reducer<State, Action> = (State, Action) -> State
    private let reducer: Reducer<State, Action>

    init(initialState: State, reducer: @escaping Reducer<State, Action>) {
        self.state = initialState
        self.reducer = reducer
    }

    func send(_ action: Action) {
        state = reducer(state, action)
    }
}
