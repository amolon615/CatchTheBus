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

extension PublicRouteModel {
    static let test: [PublicRouteModel] = [
        .init(
            id: 1685013,
            departure: PublicScheduleModel.depTest1,
            arrival: PublicScheduleModel.arrTest1,
            location: PublicLocationModel.test1,
            allow_boarding: true,
            allow_drop_off: false,
            booking_cut_off_mins: 0,
            pre_booked_only: false,
            skipped: false
        ),
        .init(
            id: 1685014,
            departure: PublicScheduleModel.depTest2,
            arrival: PublicScheduleModel.arrTest2,
            location: PublicLocationModel.test2,
            allow_boarding: true,
            allow_drop_off: false,
            booking_cut_off_mins: 0,
            pre_booked_only: true,
            skipped: true
        ),
        .init(
            id: 1685015,
            departure: PublicScheduleModel.depTest3,
            arrival: PublicScheduleModel.arrTest3,
            location: PublicLocationModel.test3,
            allow_boarding: true,
            allow_drop_off: false,
            booking_cut_off_mins: 0,
            pre_booked_only: true,
            skipped: false
        ),
        .init(
            id: 1685016,
            departure: PublicScheduleModel.depTest4,
            arrival: PublicScheduleModel.arrTest4,
            location: PublicLocationModel.test4,
            allow_boarding: true,
            allow_drop_off: false,
            booking_cut_off_mins: 0,
            pre_booked_only: true,
            skipped: false
        )
    ]
}
