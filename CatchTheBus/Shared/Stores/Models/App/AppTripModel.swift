//
//  AppTripModel.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct AppTripModel: Decodable {
    let route: [AppRouteModel]
    let vehicle: AppVehicleModel
    let description: AppRouteDescriptionModel
}

extension AppTripModel {
    var test: AppTripModel {
        .init(
            route: AppRouteModel.test,
            vehicle: .test,
            description: .test
        )
    }
}
