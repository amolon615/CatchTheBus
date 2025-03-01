//
//  PublicCoordinateModel.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct PublicCoordinateModel: Decodable {
    let latitude: Double
    let longitude: Double
}

extension PublicCoordinateModel {
    var appModel: AppCoordinateModel {
        AppCoordinateModel(
            latitude: latitude,
            longitude: longitude
        )
    }
}
