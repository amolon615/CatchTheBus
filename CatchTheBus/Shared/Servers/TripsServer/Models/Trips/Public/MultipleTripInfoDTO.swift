//
//  MultipleTripInfoDTO.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct MultipleTripInfoDTO: Decodable, Sendable, Equatable {
    let quotes: [PublicQuote]
    let min_card_transaction: Int
}

extension MultipleTripInfoDTO {
    var appModel: AppMultipleTripInfoDTO {
        .init(
            quotes: quotes.map { $0.appModel },
            minCardTransaction: min_card_transaction
        )
    }
}
