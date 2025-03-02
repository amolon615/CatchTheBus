//
//  Root.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct PublicAmenities: Decodable, Equatable {
    let has_wifi: Bool
    let has_toilet: Bool
}

extension PublicAmenities {
    var appModel: AppAmenities {
        .init(
            hasWifi: has_wifi,
            hasToilet: has_toilet
        )
    }
}

extension PublicAmenities {
    static let test: PublicAmenities = .init(
        has_wifi: true,
        has_toilet: true
    )
}
