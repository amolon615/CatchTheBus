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
