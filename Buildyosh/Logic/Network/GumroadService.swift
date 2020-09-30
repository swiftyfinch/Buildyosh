//
//  GumroadService.swift
//  Buildyosh
//
//  Created by Vyacheslav Khorkov on 27.09.2020.
//  Copyright © 2020 Vyacheslav Khorkov. All rights reserved.
//

import Foundation
import Combine

private struct GumroadResponse: Decodable {
    struct Purchase: Decodable {
        let refunded: Bool
        let chargebacked: Bool
    }

    let message: String?
    let success: Bool
    let purchase: Purchase?
}

final class GumroadService {
    private let baseURL = URL(string: "https://api.gumroad.com/v2/licenses/verify")!
    private let productId = "HYzCu"
    private let keychainService = KeychainService()

    func verify(key: String) -> AnyPublisher<Action, Never> {
        let trimmedKey = key.trimmingCharacters(in: .whitespacesAndNewlines)
        var request = URLRequest(url: baseURL)
        request.httpMethod = "POST"
        request.httpBody = "product_permalink=\(productId)&license_key=\(trimmedKey)".data(using: .utf8)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { data, response in
                do {
                    let gumroad = try JSONDecoder().decode(GumroadResponse.self, from: data)
                    if gumroad.success, let purchase = gumroad.purchase {
                        if purchase.refunded {
                            return .errorOnboarding("You made a refund on Gumroad service. Buy another one key if wanted.")
                        } else if purchase.chargebacked {
                            return .errorOnboarding("You got chargeback on Gumroad service. Buy another one key if wanted.")
                        } else {
                            self.keychainService.saveKey(trimmedKey)
                            return .finishOnboarding
                        }
                    } else if let message = gumroad.message {
                        return .errorOnboarding(message)
                    } else {
                        return .errorOnboarding("Gumroad service error. Try to update the app or contact me.")
                    }
                } catch {
                    return .errorOnboarding("Gumroad service error. Try to update the app or contact me.")
                }
            }
            .replaceError(with: .errorOnboarding("Connection issue. Check your internet or try again later."))
            .eraseToAnyPublisher()
    }
}
