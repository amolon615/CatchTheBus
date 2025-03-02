//
//  AppTripsServer.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation
import SwiftUI

final actor AppTripsServer: TripServer {
    private let httpClient: HTTPClientProtocol
    private(set) var trips: MultipleTripInfoDTO?
    
    init(httpClient: HTTPClientProtocol) {
        self.httpClient = httpClient
    }
    
    func fetchTrips(fromDate: Date, toDate: Date) async throws {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]

        let fromString = isoFormatter.string(from: fromDate)
        let toString   = isoFormatter.string(from: toDate)
        
        let client = self.httpClient
        let response: MultipleTripInfoDTO = try await client.request(
            endpoint: Constants.TripsServer.getAllTripsInfoUR(fromDate: fromString, toDate: toString)
        )
        
        self.trips = response
    }
    
    func fetchOneTrip(withID id: String) async throws -> AppTripModel? {
        let client = self.httpClient
        let response: PublicTripModel = try await client.request(
            endpoint: Constants.TripsServer.getOneTripDetailedInfoURL(withID: id)
        )
        return response.appModel
    }
}
