//
//  PublicTripModel.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct PublicTripModel: Decodable {
    let route: [PublicRouteModel]
    let vehicle: PublicVehicleModel
    let description: PublicRouteDescriptionModel
}

extension PublicTripModel {
    var appModel: AppTripModel {
        .init(
            route: route.map { $0.appModel },
            vehicle: vehicle.appModel,
            description: description.appModel
        )
    }
}
