//
//  PublicRouteModel.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct PublicRouteModel: Decodable {
    let id: Int
    let departure: PublicScheduleModel
    let arrival: PublicScheduleModel
    let location: PublicLocationModel
    let allow_boarding: Bool
    let allow_drop_off: Bool
    let booking_cut_off_mins: Int
    let pre_booked_only: Bool
    let skipped: Bool
}

extension PublicRouteModel {
    var appModel: AppRouteModel {
        .init(
            id: id,
            departure: departure.appModel,
            arrival: arrival.appModel,
            location: location.appModel,
            allowBoarding: allow_boarding,
            allowDropOff: allow_drop_off,
            bookingCutOffMins: booking_cut_off_mins,
            preBookedOnly: pre_booked_only,
            skipped: skipped
        )
    }
}
