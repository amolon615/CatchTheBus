//
//  AppLocation.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct AppLocation: Decodable, Hashable {
    let id: Int
    let atcoCode: String
    let detailedName: String
    let lat: Double
    let lon: Double
    let name: String
    let regionName: String
    let type: String
    let code: String
    let codeDetail: String
    let timezone: String
    let heading: Int
    let zone: [AppCoordinateModel]
    let hasFutureActivity: Bool
    let areaId: Int
    let locationTimeId: Int
    let bookingCutOffMins: Int
    let preBookedOnly: Bool
    let skipped: Bool
    let bookable: String
}

extension AppLocation {
    static var testOrigin: AppLocation {
        .init(
            id: 218,
            atcoCode: "6400LL99",
            detailedName: "Slessor Gardens",
            lat: 56.459319,
            lon: -2.966036,
            name: "Dundee Slessor Gardens",
            regionName: "Dundee",
            type: "STOP_POINT",
            code: "DUND",
            codeDetail: "Dundee",
            timezone: "Europe/London",
            heading: 135,
            zone: AppCoordinateModel.testCoordinates1,
            hasFutureActivity: true,
            areaId: 13,
            locationTimeId: 1685013,
            bookingCutOffMins: 0,
            preBookedOnly: false,
            skipped: false,
            bookable: "2025-03-01T15:00:00+00:00"
        )
    }

    static var testDestination: AppLocation {
        .init(
            id: 175,
            atcoCode: "6200206490",
            detailedName: "George Street (Stop GL)",
            lat: 55.95395,
            lon: -3.19549,
            name: "George Street",
            regionName: "Edinburgh",
            type: "STOP_POINT",
            code: "EDIN",
            codeDetail: "Edinburgh",
            timezone: "Europe/London",
            heading: 75,
            zone: AppCoordinateModel.testCoordinates1,
            hasFutureActivity: true,
            areaId: 42,
            locationTimeId: 1685026,
            bookingCutOffMins: 0,
            preBookedOnly: false,
            skipped: false,
            bookable: "2025-03-01T16:55:00+00:00"
        )
    }
}
