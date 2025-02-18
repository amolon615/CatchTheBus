//
//  BusDetailView.swift
//  CatchTheBus
//
//  Created by amolonus on 18/02/2025.
//
import SwiftUI
import MapKit

// MARK: - Bus Detail View

struct BusDetailView: View {
    let bus: Bus
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading, spacing: 10) {
                Text("Plate Number: \(bus.plate_number)")
                Text("Brand: \(bus.brand)")
                Text("Type: \(bus.type)")
                Text("Colour: \(bus.colour)")
                Text("Has WiFi: \(bus.has_wifi ? "Yes" : "No")")
                Text("Has Toilet: \(bus.has_toilet ? "Yes" : "No")")
                
                if let gps = bus.gps {
                    Text("Last Updated: \(gps.last_updated)")
                    Text("Latitude: \(gps.latitude)")
                    Text("Longitude: \(gps.longitude)")
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Bus Details")
            .navigationBarItems(trailing: Button("Done") {
                presentationMode.wrappedValue.dismiss()
            })
        }
    }
}
