//
//  AppQuote.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct AppQuote: Decodable {
    let availability: AppAvailability
    let prices: AppPrices
    let legs: [AppLeg]
    let bookable: Bool
}

extension AppQuote {
    static var test: AppQuote {
        .init(
            availability: .test,
            prices: .test,
            legs: [.test],
            bookable: true
        )
    }
}
