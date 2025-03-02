//
//  UITripViewModel.swift
//  CatchTheBus
//
//  Created by amolonus on 02/03/2025.
//
import Foundation

@MainActor
final class UITripViewModel: ObservableObject {
    let tripID: String
    let tripsServer: AppTripsServer
    
    @Published var currentTrip: AppTripModel?
    
    init(tripID: String, tripsServer: AppTripsServer) {
        self.tripID = tripID
        self.tripsServer = tripsServer
    }
    
    func fetchTripInfo() async {
        do {
            currentTrip = try await tripsServer.fetchOneTrip(withID: tripID)
        } catch let error {
            print("Error loading trip details: \(error.localizedDescription)")
        }
    }
}
