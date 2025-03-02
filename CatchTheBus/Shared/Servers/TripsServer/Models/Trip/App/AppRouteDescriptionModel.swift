//
//  AppTripModel.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//

import Foundation

struct AppRouteDescriptionModel: Codable {
    let routeNumber: String
    let patternId: Int
    let calendarDate: String
    let type: String
    let isCancelled: Bool
    let routeId: Int
}

extension AppRouteDescriptionModel {
    static let test: AppRouteDescriptionModel =
        .init(
            routeNumber: "E1",
            patternId: 37246,
            calendarDate: "2025-03-01",
            type: "public",
            isCancelled: false,
            routeId: 1
        )
}
