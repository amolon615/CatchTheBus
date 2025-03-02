//
//  PublicLocation.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct PublicLocation: Decodable, Equatable {
    let id: Int
    let atco_code: String
    let detailed_name: String
    let lat: Double
    let lon: Double
    let name: String
    let region_name: String
    let type: String
    let code: String
    let code_detail: String
    let timezone: String
    let heading: Double
    let zone: [PublicCoordinateModel]
    let has_future_activity: Bool
    let area_id: Int
    let location_time_id: Int
    let booking_cut_off_mins: Int
    let pre_booked_only: Bool
    let skipped: Bool
    let bookable: String
}

extension PublicLocation {
    var appModel: AppLocation {
        .init(
            id: id,
            atcoCode: atco_code,
            detailedName: detailed_name,
            lat: lat,
            lon: lon,
            name: name,
            regionName: region_name,
            type: type,
            code: code,
            codeDetail: code_detail,
            timezone: timezone,
            heading: heading,
            zone: zone.map { $0.appModel },
            hasFutureActivity: has_future_activity,
            areaId: area_id,
            locationTimeId: location_time_id,
            bookingCutOffMins: booking_cut_off_mins,
            preBookedOnly: pre_booked_only,
            skipped: skipped,
            bookable: bookable
        )
    }
}

extension PublicLocation {
    static var testOrigin: PublicLocation {
        .init(
            id: 218,
            atco_code: "6400LL99",
            detailed_name: "Slessor Gardens",
            lat: 56.459319,
            lon: -2.966036,
            name: "Dundee Slessor Gardens",
            region_name: "Dundee",
            type: "STOP_POINT",
            code: "DUND",
            code_detail: "Dundee",
            timezone: "Europe/London",
            heading: 135,
            zone: PublicCoordinateModel.testCoordinates1,
            has_future_activity: true,
            area_id: 13,
            location_time_id: 1685013,
            booking_cut_off_mins: 0,
            pre_booked_only: false,
            skipped: false,
            bookable: "2025-03-01T15:00:00+00:00"
        )
    }
    
    static var testDestination: PublicLocation {
        .init(
            id: 175,
            atco_code: "6200206490",
            detailed_name: "George Street (Stop GL)",
            lat: 55.95395,
            lon: -3.19549,
            name: "George Street",
            region_name: "Edinburgh",
            type: "STOP_POINT",
            code: "EDIN",
            code_detail: "Edinburgh",
            timezone: "Europe/London",
            heading: 75,
            zone: PublicCoordinateModel.testCoordinates1,
            has_future_activity: true,
            area_id: 42,
            location_time_id: 1685026,
            booking_cut_off_mins: 0,
            pre_booked_only: false,
            skipped: false,
            bookable: "2025-03-01T16:55:00+00:00"
        )
    }
}
