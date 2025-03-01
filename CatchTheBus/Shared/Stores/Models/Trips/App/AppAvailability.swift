//
//  AppMultipleTripInfoDTO.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//


import Foundation

struct AppAvailability: Decodable {
    let seat: Int
    let wheelchair: Int
    let bicycle: Int
}


extension AppAvailability {
    static var test: AppAvailability {
        .init(
            seat: 10,
            wheelchair: 0,
            bicycle: 2
        )
    }
}
