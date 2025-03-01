//
//  BusViewModel.swift
//  CatchTheBus
//
//  Created by amolonus on 18/02/2025.
//
import SwiftUI
import MapKit
import Combine

class BusViewModel: ObservableObject {
    // Instead of raw Bus objects, store animated ones:
    @Published var animatedBuses: [AnimatedBus] = []
    
    private var cancellable: AnyCancellable?
    
    init() {
        // Repeatedly fetch new data
        cancellable = Timer.publish(every: 1, // fetch every 5 seconds (or 1s if you really want)
                                   on: .main,
                                   in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                Task {
                    await self?.fetchBuses()
                }
            }
    }
    
    func fetchBuses() async {
        guard let url = URL(string: "https://api.ember.to/v1/vehicles/") else { return }
        
        do {
            let (data, response) = try await URLSession.shared.data(from: url)
            
            guard let httpResponse = response as? HTTPURLResponse,
                  httpResponse.statusCode == 200 else {
                throw URLError(.badServerResponse)
            }
            
            let decodedBuses = try JSONDecoder().decode([Bus].self, from: data)
            
            DispatchQueue.main.async {
                self.updateAnimatedBuses(with: decodedBuses)
            }
            
        } catch {
            print("Error fetching bus data: \(error)")
        }
    }
    
    private func updateAnimatedBuses(with newBuses: [Bus]) {
        for bus in newBuses {
            guard let gps = bus.gps else { continue }
            let newLocation = CLLocationCoordinate2D(latitude: gps.latitude,
                                                     longitude: gps.longitude)
            
            // 1) Check if we already have an AnimatedBus for this ID
            if let existingAnimatedBus = animatedBuses.first(where: { $0.id == bus.id }) {
                // Update coordinate smoothly
                existingAnimatedBus.updateCoordinate(to: newLocation)
            } else {
                // 2) If none exists, create a new one
                let animated = AnimatedBus(id: bus.id,
                                           title: bus.brand,
                                           coordinate: newLocation)
                animatedBuses.append(animated)
            }
        }
        
        let newIDs = Set(newBuses.map { $0.id })
        animatedBuses.removeAll { !newIDs.contains($0.id) }
    }
}

class AnimatedBus: Identifiable, ObservableObject, Equatable {
    let id: Int
    let title: String
    
    @Published var coordinate: CLLocationCoordinate2D
    
    init(id: Int, title: String, coordinate: CLLocationCoordinate2D) {
        self.id = id
        self.title = title
        self.coordinate = coordinate
    }
    
    func updateCoordinate(to newCoordinate: CLLocationCoordinate2D) {
        // Animate the transition from old -> new position
        withAnimation(.easeInOut(duration: 1.0)) {
            self.coordinate = newCoordinate
        }
    }
    
    static func == (lhs: AnimatedBus, rhs: AnimatedBus) -> Bool {
        return lhs.id == rhs.id
    }
}
