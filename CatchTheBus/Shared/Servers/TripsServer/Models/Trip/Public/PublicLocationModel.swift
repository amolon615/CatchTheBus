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

extension PublicLocationModel {
    static let test1: PublicLocationModel = .init(
        id: 218,
        type: "STOP_POINT",
        name: "Dundee Slessor Gardens",
        region_name: "Dundee",
        code: "DUND",
        code_detail: "Dundee",
        detailed_name: "Slessor Gardens",
        direction: nil,
        lon: -2.966036,
        lat: 56.459319,
        google_place_id: nil,
        atco_code: "6400LL99",
        has_future_activity: true,
        timezone: "Europe/London",
        zone: PublicCoordinateModel.testCoordinates1,
        heading: 135.0,
        area_id: 13
    )
    
    static let test2: PublicLocationModel = .init(
        id: 2,
        type: "STOP_POINT",
        name: "Dundee West",
        region_name: "Dundee West",
        code: "DUN",
        code_detail: "Dundee West",
        detailed_name: "Apollo Way",
        direction: nil,
        lon: -3.05468,
        lat: 56.462677,
        google_place_id: "ChIJE2gJVwlDhkgRBp7tM4HaqS0",
        atco_code: "6400L00019",
        has_future_activity: true,
        timezone: "Europe/London",
        zone: PublicCoordinateModel.testCoordinates2,
        heading: 45.0,
        area_id: 14
    )
    
    static let test3: PublicLocationModel = .init(
        id: 33,
        type: "STOP_POINT",
        name: "Longforgan",
        region_name: "Longforgan",
        code: "LFG",
        code_detail: "Longforgan",
        detailed_name: "Westbound Slip Road",
        direction: "WESTBOUND",
        lon: -3.1286,
        lat: 56.45718,
        google_place_id: "ChIJFT_RJGdBhkgRYxkAqkW68GY",
        atco_code: "64804203",
        has_future_activity: true,
        timezone: "Europe/London",
        zone: PublicCoordinateModel.testCoordinates3,
        heading: 270,
        area_id: 47
    )
    
    static let test4: PublicLocationModel = .init(
        id: 3,
        type: "STOP_POINT",
        name: "Inchture",
        region_name: "Inchture",
        code: "INCT",
        code_detail: "Inchture",
        detailed_name: "Road End (Westbound)",
        direction: "WESTBOUND",
        lon: -3.170071,
        lat: 56.447108,
        google_place_id: "ChIJa-OPGCRBhkgRqINJzMi0mc0",
        atco_code: "64800191",
        has_future_activity: true,
        timezone: "Europe/London",
        zone: PublicCoordinateModel.testCoordinates4,
        heading: 225.0,
        area_id: 15
    )
}
