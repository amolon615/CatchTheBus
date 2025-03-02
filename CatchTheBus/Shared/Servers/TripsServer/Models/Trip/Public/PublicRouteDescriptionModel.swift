//
//  TripsStore.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct PublicRouteDescriptionModel: Decodable {
    let route_number: String
    let pattern_id: Int
    let calendar_date: String
    let type: String
    let is_cancelled: Bool
    let route_id: Int
}

extension PublicRouteDescriptionModel {
    var appModel: AppRouteDescriptionModel {
        .init(
            routeNumber: route_number,
            patternId: pattern_id,
            calendarDate: calendar_date,
            type: type,
            isCancelled: is_cancelled,
            routeId: route_id
        )
    }
}

extension PublicRouteDescriptionModel {
    static let test: PublicRouteDescriptionModel = .init(
        route_number: "E1",
        pattern_id: 37246,
        calendar_date: "2025-03-01",
        type: "public",
        is_cancelled: false,
        route_id: 1
    )
}


