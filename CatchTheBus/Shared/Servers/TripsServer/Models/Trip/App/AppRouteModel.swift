//
//  AppRouteModel.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct AppRouteModel: Decodable, Equatable {
    let id: Int
    let departure: AppScheduleModel
    let arrival: AppScheduleModel
    let location: AppLocationModel
    let allowBoarding: Bool
    let allowDropOff: Bool
    let bookingCutOffMins: Int
    let preBookedOnly: Bool
    let skipped: Bool
}

extension AppRouteModel {
    static let test: [AppRouteModel] = [
        .init(
            id: 1685013,
            departure: .depTest1,
            arrival: .arrTest1,
            location: .test1,
            allowBoarding: true,
            allowDropOff: false,
            bookingCutOffMins: 0,
            preBookedOnly: false,
            skipped: false
        ),
        .init(
            id: 1685014,
            departure: .depTest2,
            arrival: .arrTest2,
            location: .test2,
            allowBoarding: true,
            allowDropOff: false,
            bookingCutOffMins: 0,
            preBookedOnly: true,
            skipped: true
        ),
        .init(
            id: 1685015,
            departure: .depTest3,
            arrival: .arrTest3,
            location: .test3,
            allowBoarding: true,
            allowDropOff: false,
            bookingCutOffMins: 0,
            preBookedOnly: true,
            skipped: false
        ),
        .init(
            id: 1685016,
            departure: .depTest4,
            arrival: .arrTest4,
            location: .test4,
            allowBoarding: true,
            allowDropOff: false,
            bookingCutOffMins: 0,
            preBookedOnly: true,
            skipped: false
        )
    ]
}

