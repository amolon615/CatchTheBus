//
//  PublicQuote.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct PublicQuote: Decodable, Equatable {
    let availability: PublicAvailability
    let prices: PublicPrices
    let legs: [PublicLeg]
    let bookable: Bool
}

extension PublicQuote {
    var appModel: AppQuote {
        .init(
            availability: availability.appModel,
            prices: prices.appModel,
            legs: legs.map { $0.appModel },
            bookable: bookable
        )
    }
}
