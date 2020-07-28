//
//  Result+Utils.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 17.07.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation

typealias Result<T> = Swift.Result<T, Error>

extension Result where Success == Void {
    static var success: Swift.Result<Void, Failure> { .success(()) }
}
