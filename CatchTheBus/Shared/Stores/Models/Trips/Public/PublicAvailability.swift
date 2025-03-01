//
//  PublicAvailability.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct PublicAvailability: Decodable {
    let seat: Int
    let wheelchair: Int
    let bicycle: Int
}

extension PublicAvailability {
    var appModel: AppAvailability {
        .init(
            seat: seat,
            wheelchair: wheelchair,
            bicycle: bicycle
        )
    }
}
