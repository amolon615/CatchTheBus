//
//  RootViewState.swift
//  CatchTheBus
//
//  Created by amolonus on 03/03/2025.
//
import Foundation

enum RootViewState: Equatable {
    case allTrips
    case trackedTrip(String)
    var title: String {
        switch self {
        case .allTrips:
            return "All trips"
        case .trackedTrip:
            return "Tracked trip"
        }
    }
}
