//
//  ContentView.swift
//  CatchTheBus
//
//  Created by amolonus on 18/02/2025.
//

import SwiftUI
import MapKit
import Combine


// MARK: - Main Map View

struct MapView: View {
    @StateObject var viewModel = BusViewModel()
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 56.0, longitude: -3.0),
        span: MKCoordinateSpan(latitudeDelta: 1.0, longitudeDelta: 1.0)
    )
    @State private var selectedBus: Bus? = nil
    
    var body: some View {
        Map(
            coordinateRegion: $region,
            annotationItems: viewModel.buses.compactMap { (bus: Bus) -> BusAnnotation? in
                guard let gps = bus.gps else { return nil }
                return BusAnnotation(
                    bus: bus,
                    coordinate: CLLocationCoordinate2D(latitude: gps.latitude, longitude: gps.longitude)
                )
            },
            annotationContent: { (busAnnotation: BusAnnotation) in
                MapAnnotation(coordinate: busAnnotation.coordinate) {
                    Button(action: {
                        selectedBus = busAnnotation.bus
                    }) {
                        Image(systemName: "bus.fill")
                            .padding(5)
                            .background(Circle().fill(Color.white.opacity(0.5)))
                            .frame(width: 20, height: 20)
                    }
                }
            }
        )
        .edgesIgnoringSafeArea(.all)
        .animation(.linear(duration: 0.5), value: viewModel.buses)
        .sheet(item: $selectedBus) { bus in
            BusDetailView(bus: bus)
        }
    }
}
