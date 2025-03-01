//
//  PublicVehicleModel.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct PublicVehicleModel: Decodable {
    let wheelchair: Int
    let bicycle: Int
    let seat: Int
    let id: Int
    let plate_number: String
    let name: String
    let has_wifi: Bool
    let has_toilet: Bool
    let type: String
    let brand: String
    let colour: String
    let is_backup_vehicle: Bool
    let owner_id: Int
    let gps: PublicGPSModel
}

extension PublicVehicleModel {
    var appModel: AppVehicleModel {
        .init(
            wheelchair: wheelchair,
            bicycle: bicycle,
            seat: seat,
            id: id,
            plateNumber: plate_number,
            name: name,
            hasWifi: has_wifi,
            hasToilet: has_toilet,
            type: type,
            brand: brand,
            colour: colour,
            isBackupVehicle: is_backup_vehicle,
            ownerId: owner_id,
            gps: gps.appModel
        )
    }
}
