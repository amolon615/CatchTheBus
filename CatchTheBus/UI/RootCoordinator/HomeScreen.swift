//
//  HomeScreen.swift
//  CatchTheBus
//
//  Created by amolonus on 18/02/2025.
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

enum RootViewState {
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

struct HomeScreen: View {
    @StateObject var viewModel: UIRootCoordinatorViewModel
    @EnvironmentObject private var appDependencies: AppDependencies
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .allTrips:
                    tripsFeed
                case .trackedTrip(let tripUID):
                    trackedTripView(tripUID: tripUID)
                }
            }
        }
    }
    
    @ViewBuilder
    private var tripsFeed: some View {
        let viewModel: UITripsFeedViewModel = .init(server: appDependencies.tripServer)
        TripsFeedView(viewModel: viewModel) { selectedTripID in
            self.viewModel.trackTrip(selectedTripID)
        }
        .environmentObject(appDependencies)
    }
    
    @ViewBuilder
    private func trackedTripView(tripUID: String) -> some View {
        let viewModel: UITripViewModel = .init(tripID: tripUID, tripsServer: appDependencies.tripServer)
        CurrentTripView(viewModel: viewModel) {
            self.viewModel.untrackTrip()
        }
    }
}


