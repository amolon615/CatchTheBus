//
//  MockTripsFeedViewModel.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

@MainActor
final class MockTripsFeedViewModel: TripsFeedViewModel {
    @Published private(set) var trips: [AppQuote] = []
    @Published private(set) var state: TripsFeedViewModelState
    
    init(state: TripsFeedViewModelState) {
        self.state = state
        switch state {
        case .idle:
            trips = []
        case .empty:
            trips = []
        case .loading:
            trips = []
        case .data:
            trips = Array(repeating: AppQuote.test, count: 30)
        case .error:
            trips = []
        }
    }
    func fetchTrips(from: Date, to: Date) async {}
    
    private func loadTrips() async {}
}
