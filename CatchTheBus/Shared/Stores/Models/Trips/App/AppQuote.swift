//
//  AppQuote.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct AppQuote: Identifiable {
    let id: UUID = UUID()
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

extension AppQuote: Hashable {
    func hash(into hasher: inout Hasher) {
        hasher.combine(availability.hashValue)
        hasher.combine(prices.hashValue)
        hasher.combine(bookable)
    }
}

extension AppQuote: Equatable {
    static func == (lhs: AppQuote, rhs: AppQuote) -> Bool {
        return lhs.availability == rhs.availability && lhs.prices == rhs.prices
    }
}
