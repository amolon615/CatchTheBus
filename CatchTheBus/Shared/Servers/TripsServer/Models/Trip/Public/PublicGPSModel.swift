//
//  PublicGPSModel.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct PublicGPSModel: Decodable {
    let last_updated: String
    let longitude: Double
    let latitude: Double
    let heading: Double
}

extension PublicGPSModel {
    var appModel: AppGPSModel {
        .init(
            lastUpdated: last_updated,
            longitude: longitude,
            latitude: latitude,
            heading: heading
        )
    }
}

extension PublicGPSModel {
    static let test: PublicGPSModel = .init(
        last_updated: "2025-03-01T17:05:37.046000+00:00",
        longitude: -3.1950566,
        latitude: 55.9538466,
        heading: 338
    )
}
