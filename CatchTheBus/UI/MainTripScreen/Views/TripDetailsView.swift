//
//  TripDetailsView.swift
//  CatchTheBus
//
//  Created by amolonus on 03/03/2025.
//
import SwiftUI

struct TripDetailsView: View {
    let trip: AppTripModel
    @Binding var showDetails: Bool
    var animation: Namespace.ID
    
    var body: some View {
        NavigationStack {
            // Details card
            VStack(alignment: .leading, spacing: 16) {
                // Bus image with matched geometry effect
                Image("emberBus")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                    .matchedGeometryEffect(id: "busImage", in: animation)
                
                // Bus details
                Group {
                    HStack(alignment: .center) {
                        Text(trip.vehicle.brand)
                            .font(.title2)
                            .bold()
                        
                        Spacer()
                        
                        // Bus color indicator
                        HStack {
                            Circle()
                                .fill(Color(trip.vehicle.colour.lowercased()))
                                .frame(width: 20, height: 20)
                            
                            Text(trip.vehicle.colour)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Divider()
                    
                    // Vehicle details
                    DetailRow(icon: "bus", title: "Vehicle Type", value: trip.vehicle.type)
                    DetailRow(icon: "creditcard", title: "Plate Number", value: trip.vehicle.plateNumber)
                    DetailRow(icon: "person.2.fill", title: "Seats", value: "\(trip.vehicle.seat)")
                    
                    // Amenities
                    HStack(spacing: 20) {
                        AmenityView(
                            available: trip.vehicle.hasWifi,
                            icon: "wifi",
                            label: "WiFi"
                        )
                        
                        AmenityView(
                            available: trip.vehicle.hasToilet,
                            icon: "toilet",
                            label: "Toilet"
                        )
                        
                        AmenityView(
                            available: trip.vehicle.wheelchair > 0,
                            icon: "figure.roll",
                            label: "Wheelchair"
                        )
                        
                        AmenityView(
                            available: trip.vehicle.bicycle > 0,
                            icon: "bicycle",
                            label: "Bicycle"
                        )
                    }
                    .padding(.top, 8)
                }
                .padding(.horizontal, 8)
            }
            .padding()
            .background(Color(.systemBackground))
            .cornerRadius(16)
            .shadow(radius: 20)
            .padding()
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        withAnimation(.spring()) {
                            showDetails = false
                        }
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.title2)
                            .foregroundColor(.gray)
                    }
                }
            }
        }
    }
}

// Helper views
struct DetailRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack {
            Image(systemName: icon)
                .frame(width: 30)
                .foregroundColor(.secondary)
            
            Text(title)
                .foregroundColor(.secondary)
            
            Spacer()
            
            Text(value)
                .bold()
        }
        .padding(.vertical, 4)
    }
}

struct AmenityView: View {
    let available: Bool
    let icon: String
    let label: String
    
    var body: some View {
        VStack {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(available ? .blue : .gray.opacity(0.5))
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 8)
        .background(available ? Color.blue.opacity(0.1) : Color.gray.opacity(0.1))
        .cornerRadius(8)
    }
}
