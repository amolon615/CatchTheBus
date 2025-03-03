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
    
    @Published var tripError: TripFetchError?
    @Published var showErrorAlert: Bool = false
    
    private var updateTask: Task<Void, Never>?
    
    init(tripID: String, tripsServer: AppTripsServer, networkObserver: NetworkObserver) {
        self.tripID = tripID
        self.tripsServer = tripsServer
        self.networkObserver = networkObserver
    }
    
    func fetchTripInfo() async {
        do {
            let updatedTrip = try await tripsServer.fetchOneTrip(withID: tripID)
            tripError = nil
            showErrorAlert = false
            currentTrip = updatedTrip
            
            if isLiveActivityEnabled, let trip = currentTrip {
                LiveActivityManager.shared.updateLiveActivity(with: trip)
            }
        } catch let error {
            if let nsError = error as NSError? {
                // Check for HTTP status codes
                if nsError.domain == NSURLErrorDomain || nsError.domain.contains("HTTP") {
                    if nsError.code == 403 {
                        tripError = .tripExpired
                    } else if nsError.code == 404 {
                        tripError = .notFound
                    } else {
                        tripError = .networkError(nsError)
                    }
                }
                else if nsError.domain == "YourAppErrorDomain" {
                    if nsError.code == 404 {
                        tripError = .notFound
                    } else if nsError.code == 403 {
                        tripError = .tripExpired
                    } else {
                        tripError = .unknown(nsError)
                    }
                } else {
                    tripError = .unknown(nsError)
                }
            }
            else if let serverError = error as? TripFetchError {
                tripError = serverError
            }
            else {
                tripError = .unknown(error)
            }
            showErrorAlert = true
        }
    }

    
    func startUpdatingTripInfo() {
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
    }
}


enum TripFetchError: Error, LocalizedError {
    case tripExpired
    case networkError(Error)
    case notFound
    case serverError(String)
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .tripExpired:
            return "This trip has expired or is no longer available."
        case .networkError(let error):
            return "Network error: \(error.localizedDescription)"
        case .notFound:
            return "Trip not found. It may have been cancelled."
        case .serverError(let message):
            return "Server error: \(message)"
        case .unknown(let error):
            return "An unexpected error occurred: \(error.localizedDescription)"
        }
    }
}
