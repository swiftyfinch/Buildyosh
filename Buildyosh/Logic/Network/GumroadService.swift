//
//  GumroadService.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 27.09.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation
import Combine

final class GumroadService {

    private let baseURL = URL(string: "https://api.gumroad.com/v2/licenses/verify")!
    private let productId = "HYzCu"

    func verify(key: String) -> AnyPublisher<(data: Data, response: URLResponse), URLError> {
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.httpBody = "product_permalink=\(productId)&license_key=\(key)".data(using: .utf8)
        return URLSession.shared.dataTaskPublisher(for: request)
            .eraseToAnyPublisher()
    }
}
