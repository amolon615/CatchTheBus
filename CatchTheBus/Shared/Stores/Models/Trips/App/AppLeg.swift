//
//  AppLeg.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct AppLeg: Decodable {
    let type: String
    let tripUid: String
    let addsCapacityForTripUid: String?
    let origin: AppLocation
    let destination: AppLocation
    let departure: AppScheduleModel
    let arrival: AppScheduleModel?
    let description: AppLegDescription
    let tripType: String
}

extension AppLeg {
    static var test: AppLeg {
        .init(
            type: "scheduled_transit",
            tripUid: "T9nybGfxnQV4UUrUECS9Yt",
            addsCapacityForTripUid: nil,
            origin: .testOrigin,
            destination: .testDestination,
            departure: .arrTest1,
            arrival: .depTest1,
            description: .test,
            tripType: "public"
        )
    }
}
