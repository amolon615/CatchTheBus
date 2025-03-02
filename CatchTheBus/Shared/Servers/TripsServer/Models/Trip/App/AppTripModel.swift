//
//  AppTripModel.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct AppTripModel: Decodable, Equatable {
    let route: [AppRouteModel]
    let vehicle: AppVehicleModel
    let description: AppRouteDescriptionModel
}

extension AppTripModel {
    static var test: AppTripModel {
        .init(
            route: AppRouteModel.test,
            vehicle: .test,
            description: .test
        )
    }
}
