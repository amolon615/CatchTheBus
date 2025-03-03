//
//  TripRowView.swift
//  CatchTheBus
//
//  Created by amolonus on 03/03/2025.
//
import SwiftUI

struct TripRowView: View {
    let leg: AppLeg
    
    private func formatDateTime(_ dateString: String) -> String {
        guard let date = ISO8601DateFormatter().date(from: dateString) else {
            return "Unknown time"
        }
        
        let formatter = DateFormatter()
        formatter.dateStyle = .none
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image("emberBus")
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(leg.origin.name)
                        .font(.headline)
                    Image(systemName: "arrow.right")
                        .foregroundColor(.gray)
                    Text(leg.destination.name)
                        .font(.headline)
                }
                
                HStack {
                    Text("Departure: \(formatDateTime(leg.departure.scheduled))")
                        .font(.subheadline)
                    Spacer()
                    if let arrival = leg.arrival {
                        Text("Arrival: \(formatDateTime(arrival.scheduled))")
                            .font(.subheadline)
                    }
                }
                
                HStack {
                    Text(leg.description.brand)
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("•")
                        .foregroundColor(.secondary)
                    
                    Text("\(leg.description.vehicleType) - \(leg.description.colour)")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    if leg.description.isElectric {
                        Image(systemName: "bolt.fill")
                            .foregroundColor(.green)
                    }
                }
                
                HStack {
                    if leg.description.amenities.hasWifi {
                        Label("WiFi", systemImage: "wifi")
                            .font(.caption2)
                            .foregroundColor(.blue)
                            .labelStyle(.iconOnly)
                    }
                    
                    if leg.description.amenities.hasToilet {
                        Label("Toilet", systemImage: "figure.dress.line.vertical.figure")
                            .font(.caption2)
                            .foregroundColor(.purple)
                            .labelStyle(.iconOnly)
                    }
                }
            }
        }
        .padding(.vertical, 8)
    }
}
