//
//  AppLocationModel.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct AppLocationModel: Decodable {
    let id: Int
    let type: String
    let name: String
    let regionName: String
    let code: String
    let codeDetail: String
    let detailedName: String
    let direction: String?
    let lon: Double
    let lat: Double
    let googlePlaceId: String?
    let atcoCode: String
    let hasFutureActivity: Bool
    let timezone: String
    let zone: [AppCoordinateModel]
    let heading: Double
    let areaId: Int
}

extension AppLocationModel {
    static var test1: AppLocationModel =
        .init(
            id: 218,
            type: "STOP_POINT",
            name: "Dundee Slessor Gardens",
            regionName: "Dundee",
            code: "DUND",
            codeDetail: "Dundee",
            detailedName: "Slessor Gardens",
            direction: nil,
            lon: -2.966036,
            lat: 56.459319,
            googlePlaceId: nil,
            atcoCode: "6400LL99",
            hasFutureActivity: true,
            timezone: "Europe/London",
            zone: AppCoordinateModel.testCoordinates1,
            heading: 135.0,
            areaId: 13
        )
    
    static var test2: AppLocationModel =
        .init(
            id: 2,
            type: "STOP_POINT",
            name: "Dundee West",
            regionName: "Dundee West",
            code: "DUN",
            codeDetail: "Dundee West",
            detailedName: "Apollo Way",
            direction: nil,
            lon: -3.05468,
            lat: 56.462677,
            googlePlaceId: "ChIJE2gJVwlDhkgRBp7tM4HaqS0",
            atcoCode: "6400L00019",
            hasFutureActivity: true,
            timezone: "Europe/London",
            zone: AppCoordinateModel.testCoordinates2,
            heading: 45.0,
            areaId: 14
        )
    
    static var test3: AppLocationModel =
        .init(
            id: 33,
            type: "STOP_POINT",
            name: "Longforgan",
            regionName: "Longforgan",
            code: "LFG",
            codeDetail: "Longforgan",
            detailedName: "Westbound Slip Road",
            direction: "WESTBOUND",
            lon: -3.1286,
            lat: 56.45718,
            googlePlaceId: "ChIJFT_RJGdBhkgRYxkAqkW68GY",
            atcoCode: "64804203",
            hasFutureActivity: true,
            timezone: "Europe/London",
            zone: AppCoordinateModel.testCoordinates3,
            heading: 270,
            areaId: 47
        )
    
    static var test4: AppLocationModel =
        .init(
            id: 3,
            type: "STOP_POINT",
            name: "Inchture",
            regionName: "Inchture",
            code: "INCT",
            codeDetail: "Inchture",
            detailedName: "Road End (Westbound)",
            direction: "WESTBOUND",
            lon: -3.170071,
            lat: 56.447108,
            googlePlaceId: "ChIJa-OPGCRBhkgRqINJzMi0mc0",
            atcoCode: "64800191",
            hasFutureActivity: true,
            timezone: "Europe/London",
            zone: AppCoordinateModel.testCoordinates4,
            heading: 225.0,
            areaId: 15
        )
}
