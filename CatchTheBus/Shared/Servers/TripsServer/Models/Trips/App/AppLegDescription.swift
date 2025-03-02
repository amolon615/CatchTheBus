//
//  AppLegDescription.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct AppLegDescription: Decodable, Hashable {
    let brand: String
    let `operator`: String
    let destinationBoard: String
    let numberPlate: String
    let vehicleType: String
    let colour: String
    let amenities: AppAmenities
    let isElectric: Bool
}

extension AppLegDescription {
    static var test: AppLegDescription {
        .init(
            brand: "Ember",
            operator: "Ember",
            destinationBoard: "E1",
            numberPlate: "SG23 ORP",
            vehicleType: "coach",
            colour: "Black",
            amenities: .test,
            isElectric: true
        )
    }
}
