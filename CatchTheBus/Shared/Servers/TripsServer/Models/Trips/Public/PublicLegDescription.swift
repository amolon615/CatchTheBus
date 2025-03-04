//
//  PublicLegDescription.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct PublicLegDescription: Decodable, Equatable {
    let brand: String
    let `operator`: String
    let destination_board: String
    let number_plate: String
    let vehicle_type: String
    let colour: String
    let amenities: PublicAmenities
    let is_electric: Bool
}

extension PublicLegDescription {
    var appModel: AppLegDescription {
        .init(
            brand: brand,
            operator: `operator`,
            destinationBoard: destination_board,
            numberPlate: number_plate,
            vehicleType: vehicle_type,
            colour: colour,
            amenities: amenities.appModel,
            isElectric: is_electric
        )
    }
}

extension PublicLegDescription {
    static let test: PublicLegDescription = .init(
        brand: "Ember",
        operator: "Ember",
        destination_board: "E1",
        number_plate: "SG23 ORP",
        vehicle_type: "coach",
        colour: "Black",
        amenities: PublicAmenities.test,
        is_electric: true
    )
}
