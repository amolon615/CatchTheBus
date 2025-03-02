//
//  UITripsFeedViewModel.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

@MainActor
final class UITripsFeedViewModel: TripsFeedViewModel {
    @Published private(set) var trips: [AppQuote] = []
    @Published private(set) var state: TripsFeedViewModelState = .idle
    
    let server: AppTripsServer
    
    init(server: AppTripsServer) {
        self.server = server
    }
    
    
    func fetchTrips(from: Date, to: Date) async {
        state = .loading
        do {
            try await server.fetchTrips(fromDate: from, toDate: to)
            await loadTrips()
        } catch let error {
            print("Error loading trips: \(error.localizedDescription)")
            self.state = .error
        }
    }
    
    private func loadTrips() async {
        guard let trips = await server.trips else { return }
        self.trips = trips.quotes.map({ $0.appModel })
        self.state = self.trips.isEmpty ? .empty : .data
    }
}
