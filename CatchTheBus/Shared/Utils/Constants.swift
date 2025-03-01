//
//  Constants.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//


struct Constants {
    static let baseURL: String = "https://api.ember.to/v1"
    
    static func getAllTripsInfoUR(fromDate from: String, toDate to: String) -> String { "quotes/?origin=13&destination=42&departure_date_from=\(from)&departure_date_to=\(to)"
    }
    
    static func getOneTripDetailedInfoURL(withID tripdID: String) -> String {
        return "/trips/\(tripdID)/"
    }
}
