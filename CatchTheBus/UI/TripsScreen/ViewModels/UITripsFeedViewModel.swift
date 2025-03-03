//
//  UITripsFeedViewModel.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import SwiftUI

@MainActor
final class UITripsFeedViewModel: TripsFeedViewModel {
    @Published private(set) var state: TripsFeedViewModelState = .idle
    @Published var searchField: String = ""
    @Published var isRefreshing: Bool = false
    
    private var refreshTask: Task<Void, Never>?
    
    private(set) var rawTripsData: [AppQuote] = [] {
        didSet {
            objectWillChange.send()
        }
    }
    
    // Data loading policy properties
    private var lastLoadTime: Date?
    private let minimumRefreshInterval: TimeInterval = 300 // 5 minutes
    
    var trips: [AppQuote] {
        if searchField.isEmpty {
            return rawTripsData
        } else {
            return rawTripsData.filter { $0.legs.contains {
                $0.destination.regionName.lowercased().contains(searchField.lowercased()) ||
                $0.origin.regionName.lowercased().contains(searchField.lowercased())
            } }
        }
    }
    
    let server: AppTripsServer
    
    init(server: AppTripsServer) {
        self.server = server
    }
    
    // Check if we should load data based on context
    private func shouldLoadData(context: DataLoadingContext) -> Bool {
        switch context {
        case .pullToRefresh:
            // Always allow loading for pull-to-refresh
            return true
            
        case .initial:
            // For initial/background loads, check the time interval
            guard let lastLoadTime = lastLoadTime else {
                // No previous load, so should load
                return true
            }
            
            let timeSinceLastLoad = Date().timeIntervalSince(lastLoadTime)
            return timeSinceLastLoad >= minimumRefreshInterval
        }
    }
    
    private func initialLoadIfNeeded() async {
        if shouldLoadData(context: .initial) {
            let now = Date()
            let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now) ?? now
            await fetchTrips(from: now, to: tomorrow, context: .initial)
        } else {
            // If we don't need to fetch, just load from cache
            await loadTrips()
        }
    }
    
    func fetchTrips(from: Date, to: Date, context: DataLoadingContext = .initial) async {
        refreshTask?.cancel()
        refreshTask = Task {
            do {
                print("Fetching trips with context: \(context)")
                
                if context == .pullToRefresh {
                    // Start loading state
                    state = .loading
                    isRefreshing = true
                    
                    do {
                        try Task.checkCancellation()
                        try await server.fetchTrips(fromDate: from, toDate: to)
                        
                        try Task.checkCancellation()
                        await loadTrips()
                        lastLoadTime = Date()
                    } catch is CancellationError {
                        print("Pull-to-refresh was cancelled")
                        // Don't update state if cancelled
                    } catch let error {
                        if !Task.isCancelled {
                            print("Error loading trips: \(error.localizedDescription)")
                            self.state = .error
                        }
                    }
                    
                    if !Task.isCancelled {
                        isRefreshing = false
                    }
                    return
                }
                
                if context == .initial {
                    if let lastLoadTime = lastLoadTime,
                       Date().timeIntervalSince(lastLoadTime) < minimumRefreshInterval {
                        return
                    }
                    
                    state = .loading
                    
                    do {
                        try Task.checkCancellation()
                        try await server.fetchTrips(fromDate: from, toDate: to)
                        
                        try Task.checkCancellation()
                        await loadTrips()
                        lastLoadTime = Date()
                    } catch is CancellationError {
                        print("Initial data fetch was cancelled")
                        // Don't update state if cancelled
                    } catch let error {
                        if !Task.isCancelled {
                            print("Error loading trips: \(error.localizedDescription)")
                            self.state = .error
                        }
                    }
                }
            } catch is CancellationError {
                print("Fetch trips task was cancelled")
            } catch {
                print("Unexpected error in fetch trips task: \(error)")
            }
        }
        
        if !Task.isCancelled {
            await refreshTask?.value
        }
    }
    
    deinit {
        refreshTask?.cancel()
    }
    
    
    
    private func loadTrips() async {
        guard let trips = await server.trips else { return }
        self.rawTripsData = trips.quotes.map({ $0.appModel })
        self.state = self.trips.isEmpty ? .empty : .data
    }
    
    func refreshData() async {
        let now = Date()
        let tomorrow = Calendar.current.date(byAdding: .day, value: 1, to: now) ?? now
        await fetchTrips(from: now, to: tomorrow, context: .pullToRefresh)
    }
    
    func resetLoadingState() {
        lastLoadTime = nil
    }
}


enum DataLoadingContext {
    case initial
    case pullToRefresh
}
