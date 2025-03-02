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
    let networkObserver: NetworkObserver
    
    
    
    @Published var currentTrip: AppTripModel?
    
    private var updateTask: Task<Void, Never>?
    
    init(tripID: String, tripsServer: AppTripsServer, networkObserver: NetworkObserver) {
        self.tripID = tripID
        self.tripsServer = tripsServer
        self.networkObserver = networkObserver
    }
    
    func fetchTripInfo() async {
        guard networkObserver.isConnected else {
            return
        }
        do {
            currentTrip = try await tripsServer.fetchOneTrip(withID: tripID)
        } catch let error {
            print("Error loading trip details: \(error.localizedDescription)")
        }
    }
    
    func startUpdatingTripInfo() {
        guard networkObserver.isConnected else {
            return
        }
        updateTask?.cancel()
        updateTask = Task {
            while !Task.isCancelled {
                await fetchTripInfo()
                try? await Task.sleep(nanoseconds: 2_000_000_000)
            }
        }
    }
    
    deinit {
        updateTask?.cancel()
    }
}


