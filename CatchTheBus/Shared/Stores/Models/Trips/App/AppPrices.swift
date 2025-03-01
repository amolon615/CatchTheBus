//
//  AppPrices.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct AppPrices: Decodable {
    let adult: Int
    let child: Int
    let youngChild: Int
    let concession: Int
    let seat: Int
    let wheelchair: Int
    let bicycle: Int
}

extension AppPrices {
    static var test: AppPrices {
        .init(
            adult: 850,
            child: 425,
            youngChild: 0,
            concession: 0,
            seat: 0,
            wheelchair: 0,
            bicycle: 0
        )
    }
}
