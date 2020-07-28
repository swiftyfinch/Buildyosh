//
//  XcodeLogReader.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 25.06.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation
import Gzip

struct XcodeLogReader {

    enum LocalError: Error {
        case stringConverting
    }

    func read(from url: URL) throws -> String {
        let data = try Data(contentsOf: url)
        let gunzipped = try data.gunzipped()
        guard let log = String(data: gunzipped, encoding: .ascii) else {
            throw LocalError.stringConverting
        }
        return log
    }
}
