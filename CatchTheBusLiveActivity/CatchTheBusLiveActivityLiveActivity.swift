//
//  CatchTheBusLiveActivityLiveActivity.swift
//  CatchTheBusLiveActivity
//
//  Created by amolonus on 02/03/2025.
//

import SwiftUI
import ActivityKit
import WidgetKit

// Lock Screen Live Activity View
struct BusTripLiveActivityView: View {
    let context: ActivityViewContext<BusTripAttributes>
    
    var body: some View {
        VStack(spacing: 8) {
            // Header
            HStack {
                Image(systemName: "bus.fill")
                    .font(.system(size: 18))
                    .foregroundColor(.white)
                
                Text("Route \(context.attributes.routeNumber)")
                    .font(.headline)
                    .foregroundColor(.white)
                
                Spacer()
                
                if let estimatedTime = context.state.estimatedArrivalTime {
                    Text(estimatedTime, style: .time)
                        .font(.headline)
                        .foregroundColor(context.state.isDelayed ? .red : .white)
                }
            }
            
            // Progress bar
            ProgressView(value: context.state.completedPercentage)
                .tint(Color.green)
                .background(Color.gray.opacity(0.3))
            
            // Route info
            HStack {
                VStack(alignment: .leading) {
                    Text("From: \(context.attributes.departureLocation)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                    
                    Text("To: \(context.attributes.arrivalLocation)")
                        .font(.caption)
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                VStack(alignment: .trailing) {
                    Text("Next: \(context.state.nextStopName)")
                        .font(.caption)
                        .foregroundColor(.white)
                    
                    if context.state.isDelayed {
                        Text("Delayed: \(context.state.delayMinutes) min")
                            .font(.caption)
                            .foregroundColor(.red)
                    } else {
                        Text("On time")
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .padding()
        .background(LinearGradient(colors: [Color(hex: 0x329379), Color(hex: 0x7DB8A5)], startPoint: .bottom, endPoint: .top))
        .clipShape(RoundedRectangle(cornerRadius: 15, style: .continuous))
    }
}

struct BusTripDynamicIslandCompactView: View {
    let context: ActivityViewContext<BusTripAttributes>
    
    var body: some View {
        HStack {
            Image(systemName: "bus.fill")
                .font(.system(size: 14))
            
            Text("Route \(context.attributes.routeNumber)")
                .font(.caption)
                .bold()
            
            Spacer()
            
            if let estimatedTime = context.state.estimatedArrivalTime {
                Text(estimatedTime, style: .time)
                    .font(.caption)
                    .foregroundColor(context.state.isDelayed ? .red : .primary)
            }
        }
    }
}

struct BusTripDynamicIslandExpandedView: View {
    let context: ActivityViewContext<BusTripAttributes>
    
    var body: some View {
        VStack {
            // Header
            HStack {
                Image(systemName: "bus.fill")
                    .font(.system(size: 14))
                
                Text("Route \(context.attributes.routeNumber)")
                    .font(.caption)
                    .bold()
                
                Spacer()
                
                Text("Bus \(context.state.vehicleName)")
                    .font(.caption)
            }
            
            // Progress indicator
            ProgressView(value: context.state.completedPercentage)
                .tint(Color.green)
                .background(Color.gray.opacity(0.3))
            
            // Current location
            HStack {
                Text("Current: \(context.state.currentLocation)")
                    .font(.caption2)
                
                Spacer()
                
                Text("Next: \(context.state.nextStopName)")
                    .font(.caption2)
            }
            
            // Arrival info
            HStack {
                Text("\(context.attributes.arrivalLocation)")
                    .font(.caption)
                    .bold()
                
                Spacer()
                
                if let estimatedTime = context.state.estimatedArrivalTime {
                    if context.state.isDelayed {
                        VStack(alignment: .trailing) {
                            Text(estimatedTime, style: .time)
                                .font(.caption)
                                .foregroundColor(.red)
                            
                            Text("+\(context.state.delayMinutes) min")
                                .font(.caption2)
                                .foregroundColor(.red)
                        }
                    } else {
                        Text(estimatedTime, style: .time)
                            .font(.caption)
                            .foregroundColor(.green)
                    }
                }
            }
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
    }
}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 8) & 0xff) / 255,
            blue: Double(hex & 0xff) / 255,
            opacity: alpha
        )
    }
}

