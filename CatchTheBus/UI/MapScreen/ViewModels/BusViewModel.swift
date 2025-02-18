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
    @Published var buses: [Bus] = []
    
    private var cancellable: AnyCancellable?
    
    init() {
        fetchBuses()
        cancellable = Timer.publish(every: 1, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.fetchBuses()
            }
    }
    
    func fetchBuses() {
        guard let url = URL(string: "https://api.ember.to/v1/vehicles/") else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error fetching buses: \(error)")
                return
            }
            guard let data = data else { return }
            do {
                let decodedBuses = try JSONDecoder().decode([Bus].self, from: data)
                DispatchQueue.main.async {
                    withAnimation {
                        self.buses = decodedBuses
                    }
                }
            } catch {
                print("Decoding error: \(error)")
            }
        }.resume()
    }
}
