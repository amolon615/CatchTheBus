//
//  AppTripsServer.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

final class AppTripsServer: TripServer {
    func fetchTrips() async throws -> MultipleTripInfoDTO {
        .init(quotes: [], min_card_transaction: 0)
    }
    
    func fetchOneTrip(withID id: String) async throws -> PublicTripModel? {
        return nil
    }
}
