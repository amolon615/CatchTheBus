//
//  AppMultipleTripInfoDTO 2.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct AppMultipleTripInfoDTO {
    let quotes: [AppQuote]
    let minCardTransaction: Int
}

extension AppMultipleTripInfoDTO {
    static var test: AppMultipleTripInfoDTO {
        .init(
            quotes: [.test],
            minCardTransaction: 30
        )
    }
}
