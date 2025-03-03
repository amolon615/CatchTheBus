//
//  UIRootCoordinatorViewModel.swift
//  CatchTheBus
//
//  Created by amolonus on 03/03/2025.
//
import SwiftUI

final class UIRootCoordinatorViewModel: ObservableObject {
    @Published private(set) var state: RootViewState = .allTrips
    
    @AppStorage("savedCurrentTripUID") var currentTrackedTripUID: String?
    
    
    init() {
        loadSavedTrackedTrip()
    }
    
    func loadSavedTrackedTrip() {
        if let currentTrackedTripUID = currentTrackedTripUID {
            trackTrip(currentTrackedTripUID)
        }
    }
    
    func trackTrip(_ tripUID: String) {
        currentTrackedTripUID = tripUID
        state = .trackedTrip(tripUID)
    }
    
    func untrackTrip() {
        currentTrackedTripUID = nil
        state = .allTrips
    }
}
