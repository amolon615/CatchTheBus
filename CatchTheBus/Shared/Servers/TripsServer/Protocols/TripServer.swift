//
//  TripServer.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//

import Foundation

protocol TripServer: Sendable, ObservableObject {
    func fetchTrips() async throws
    func fetchOneTrip(withID id: String) async throws -> AppTripModel?
}
