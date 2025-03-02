//
//  AppVehicleModel.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct AppVehicleModel: Codable, Equatable {
    let wheelchair: Int
    let bicycle: Int
    let seat: Int
    let id: Int
    let plateNumber: String
    let name: String
    let hasWifi: Bool
    let hasToilet: Bool
    let type: String
    let brand: String
    let colour: String
    let isBackupVehicle: Bool
    let ownerId: Int
    let gps: AppGPSModel
}

extension AppVehicleModel {
    static var test: AppVehicleModel {
        .init(
            wheelchair: 1,
            bicycle: 2,
            seat: 40,
            id: 36,
            plateNumber: "SG23 ORP",
            name: "Yutong Coach (SG23 ORP)",
            hasWifi: true,
            hasToilet: true,
            type: "coach",
            brand: "Ember",
            colour: "Black",
            isBackupVehicle: false,
            ownerId: 1,
            gps: .test
        )
    }
}
