//
//  AppGPSModel.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct AppGPSModel: Codable {
    let lastUpdated: String
    let longitude: Double
    let latitude: Double
    let heading: Double
}

extension AppGPSModel {
    static let test: AppGPSModel =
        .init(
            lastUpdated: "2025-03-01T17:05:37.046000+00:00",
            longitude: -3.1950566,
            latitude: 55.9538466,
            heading: 338
        )
}
