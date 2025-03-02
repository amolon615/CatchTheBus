//
//  PublicLocationModel.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct PublicLocationModel: Decodable {
    let id: Int
    let type: String
    let name: String
    let region_name: String
    let code: String
    let code_detail: String
    let detailed_name: String
    let direction: String?
    let lon: Double
    let lat: Double
    let google_place_id: String?
    let atco_code: String
    let has_future_activity: Bool
    let timezone: String
    let zone: [PublicCoordinateModel]
    let heading: Double
    let area_id: Int
}

extension PublicLocationModel {
    var appModel: AppLocationModel {
        .init(
            id: id,
            type: type,
            name: name,
            regionName: region_name,
            code: code,
            codeDetail: code_detail,
            detailedName: detailed_name,
            direction: direction,
            lon: lon,
            lat: lat,
            googlePlaceId: google_place_id,
            atcoCode: atco_code,
            hasFutureActivity: has_future_activity,
            timezone: timezone,
            zone: zone.map { $0.appModel },
            heading: heading,
            areaId: area_id
        )
    }
}
