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
    @Published var isLiveActivityEnabled: Bool = false
    
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
            let updatedTrip = try await tripsServer.fetchOneTrip(withID: tripID)
            currentTrip = updatedTrip
            
            // Update Live Activity if enabled
            if isLiveActivityEnabled, let trip = currentTrip {
                LiveActivityManager.shared.updateLiveActivity(with: trip)
            }
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
    
    func startLiveActivity() {
        guard let trip = currentTrip else {
            print("Cannot start Live Activity: No trip data available")
            return
        }
        
        LiveActivityManager.shared.startLiveActivity(for: trip, tripId: tripID)
        isLiveActivityEnabled = true
    }
    
    func endLiveActivity() {
        LiveActivityManager.shared.endLiveActivity()
        isLiveActivityEnabled = false
    }
    
    func toggleLiveActivity() {
        if isLiveActivityEnabled {
            endLiveActivity()
        } else {
            startLiveActivity()
        }
    }
    
    deinit {
        updateTask?.cancel()
//        if isLiveActivityEnabled {
//            endLiveActivity()
//        }
    }
}


