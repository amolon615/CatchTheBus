//
//  TripServer.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//

import Foundation

protocol TripServer {
    func fetchTrips() async throws -> MultipleTripInfoDTO
    func fetchOneTrip(withID id: String) async throws -> PublicTripModel?
}

final class TripsServer: TripServer {
    func fetchTrips() async throws -> MultipleTripInfoDTO {
        .init(quotes: [], min_card_transaction: 0)
    }
    
    func fetchOneTrip(withID id: String) async throws -> PublicTripModel? {
        return nil
    }
}
