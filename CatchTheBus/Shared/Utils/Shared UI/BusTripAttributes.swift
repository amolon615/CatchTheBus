//
//  BusTripAttributes.swift
//  CatchTheBus
//
//  Created by amolonus on 03/03/2025.
//


import Foundation
import ActivityKit
import SwiftUI

struct BusTripAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic data that will be updated
        var vehicleName: String
        var routeNumber: String
        var departureLocation: String
        var arrivalLocation: String
        var currentLocation: String
        var estimatedArrivalTime: Date?
        var scheduledArrivalTime: Date?
        var isDelayed: Bool
        var delayMinutes: Int
        var nextStopName: String
        var completedPercentage: Double // 0.0 to 1.0
        var vehicleLatitude: Double
        var vehicleLongitude: Double
        var vehicleHeading: Double
    }
    
    // Static data that won't change during the activity
    var tripId: String
    var routeNumber: String
    var departureLocation: String
    var arrivalLocation: String
    var plateNumber: String
    var calendarDate: String
}