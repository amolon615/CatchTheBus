//
//  PublicLocation.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

struct PublicLocation: Decodable {
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
    let heading: Int
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
