//
//  AppAmenities.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct AppAmenities: Decodable, Hashable {
    let hasWifi: Bool
    let hasToilet: Bool
}

extension AppAmenities {
    static var test: AppAmenities {
        .init(
            hasWifi: true,
            hasToilet: true
        )
    }
}
