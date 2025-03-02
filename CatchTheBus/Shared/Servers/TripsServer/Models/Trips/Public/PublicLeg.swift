//
//  PublicLeg.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct PublicLeg: Decodable, Equatable {
    let type: String
    let trip_uid: String
    let adds_capacity_for_trip_uid: String?
    let origin: PublicLocation
    let destination: PublicLocation
    let departure: PublicScheduleModel
    let arrival: PublicScheduleModel?
    let `description`: PublicLegDescription
    let trip_type: String
}

extension PublicLeg {
    var appModel: AppLeg {
        .init(
            type: type,
            tripUid: trip_uid,
            addsCapacityForTripUid: adds_capacity_for_trip_uid,
            origin: origin.appModel,
            destination: destination.appModel,
            departure: departure.appModel,
            arrival: arrival?.appModel,
            description: description.appModel,
            tripType: trip_type
        )
    }
}

extension PublicLeg {
    static let test: PublicLeg = .init(
        type: "scheduled_transit",
        trip_uid: "T9nybGfxnQV4UUrUECS9Yt",
        adds_capacity_for_trip_uid: nil,
        origin: PublicLocation.testOrigin,
        destination: PublicLocation.testDestination,
        departure: PublicScheduleModel.arrTest1,
        arrival: PublicScheduleModel.depTest1,
        description: PublicLegDescription.test,
        trip_type: "public"
    )
}
