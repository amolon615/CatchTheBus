//
//  HomeScreen.swift
//  CatchTheBus
//
//  Created by amolonus on 18/02/2025.
//

import SwiftUI

struct HomeScreen: View {
    @StateObject var viewModel: UIRootCoordinatorViewModel
    @EnvironmentObject private var appDependencies: AppDependencies
    @EnvironmentObject private var networkObserver: NetworkObserver
    
    var body: some View {
        NavigationStack {
            Group {
                switch viewModel.state {
                case .allTrips:
                    tripsFeed
                case .trackedTrip(let tripUID):
                    trackedTripView(tripUID: tripUID)
                        .transition(.move(edge: .bottom))
                }
            }
            .animation(.linear, value: viewModel.state)
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
        let viewModel: UITripViewModel = .init(
            tripID: tripUID,
            tripsServer: appDependencies.tripServer,
            networkObserver: networkObserver
        )
        CurrentTripView(viewModel: viewModel) {
            self.viewModel.untrackTrip()
        }
    }
}


