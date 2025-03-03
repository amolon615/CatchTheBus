//
//  BusTripAttributes.swift
//  CatchTheBus
//
//  Created by amolonus on 02/03/2025.
//


import Foundation
import ActivityKit
import SwiftUI

// 2. Create the Live Activity Manager
@MainActor
class LiveActivityManager {
    static let shared = LiveActivityManager()
    
    private var currentActivity: Activity<BusTripAttributes>?
    
    private init() {}
    
    func startLiveActivity(for trip: AppTripModel, tripId: String) {
        // Check if Activity is supported
        guard ActivityAuthorizationInfo().areActivitiesEnabled else {
            print("Live Activities not supported")
            return
        }
        
        // Check if we already have an activity for this trip
        if let existingActivity = Activity<BusTripAttributes>.activities.first(where: { $0.attributes.tripId == tripId }) {
            self.currentActivity = existingActivity
            print("Found existing activity for trip \(tripId)")
            return
        }
        
        // Create initial state
        let initialState = createContentState(from: trip)
        
        // Create attributes
        let attributes = BusTripAttributes(
            tripId: tripId,
            routeNumber: trip.description.routeNumber,
            departureLocation: trip.route.first?.location.name ?? "Unknown",
            arrivalLocation: trip.route.last?.location.name ?? "Unknown",
            plateNumber: trip.vehicle.plateNumber,
            calendarDate: trip.description.calendarDate
        )
        
        // Start the activity
        do {
            let activity = try Activity.request(
                attributes: attributes,
                contentState: initialState,
                pushType: nil
            )
            currentActivity = activity
            print("Started Live Activity with ID: \(activity.id)")
        } catch {
            print("Error starting Live Activity: \(error.localizedDescription)")
        }
    }
    
    func updateLiveActivity(with trip: AppTripModel) {
        guard let activity = currentActivity else {
            print("No active Live Activity to update")
            return
        }
        
        // Create updated state
        let updatedState = createContentState(from: trip)
        
        // Update the activity
        Task {
            await activity.update(using: updatedState)
            print("Updated Live Activity with ID: \(activity.id)")
        }
    }
    
    func endLiveActivity() {
        guard let activity = currentActivity else {
            print("No active Live Activity to end")
            return
        }
        
        Task {
            await activity.end(dismissalPolicy: .immediate)
            print("Ended Live Activity with ID: \(activity.id)")
            currentActivity = nil
        }
    }
    
    private func createContentState(from trip: AppTripModel) -> BusTripAttributes.ContentState {
        // Calculate current location and next stop
        let (currentLocation, nextStop, completedPercentage) = calculateTripProgress(trip)
        
        // Parse times
        let isoFormatter = ISO8601DateFormatter()
        var estimatedArrivalTime: Date? = nil
        var scheduledArrivalTime: Date? = nil
        var isDelayed = false
        var delayMinutes = 0
        
        if let lastStop = trip.route.last {
            if let estimatedString = lastStop.arrival.estimated,
               let estimatedDate = isoFormatter.date(from: estimatedString) {
                estimatedArrivalTime = estimatedDate
            }
            
            if let scheduledDate = isoFormatter.date(from: lastStop.arrival.scheduled) {
                scheduledArrivalTime = scheduledDate
            }
            
            // Calculate delay
            if let estimated = estimatedArrivalTime, let scheduled = scheduledArrivalTime {
                let difference = estimated.timeIntervalSince(scheduled)
                delayMinutes = Int(difference / 60)
                isDelayed = delayMinutes > 0
            }
        }
        
        return BusTripAttributes.ContentState(
            vehicleName: trip.vehicle.name,
            routeNumber: trip.description.routeNumber,
            departureLocation: trip.route.first?.location.name ?? "Unknown",
            arrivalLocation: trip.route.last?.location.name ?? "Unknown",
            currentLocation: currentLocation,
            estimatedArrivalTime: estimatedArrivalTime,
            scheduledArrivalTime: scheduledArrivalTime,
            isDelayed: isDelayed,
            delayMinutes: delayMinutes,
            nextStopName: nextStop,
            completedPercentage: completedPercentage,
            vehicleLatitude: trip.vehicle.gps.latitude,
            vehicleLongitude: trip.vehicle.gps.longitude,
            vehicleHeading: trip.vehicle.gps.heading
        )
    }
    
    private func calculateTripProgress(_ trip: AppTripModel) -> (currentLocation: String, nextStop: String, completedPercentage: Double) {
        let now = Date()
        let isoFormatter = ISO8601DateFormatter()
        
        var currentLocation = "En route"
        var nextStop = "Unknown"
        var completedPercentage: Double = 0.0
        
        // Total number of stops
        let totalStops = trip.route.count
        
        // Find current position in route
        for (index, route) in trip.route.enumerated() {
            let stopTime: Date?
            
            // Use estimated time if available, otherwise use scheduled
            if let estimatedString = route.arrival.estimated,
               let estimatedDate = isoFormatter.date(from: estimatedString) {
                stopTime = estimatedDate
            } else if let scheduledDate = isoFormatter.date(from: route.arrival.scheduled) {
                stopTime = scheduledDate
            } else {
                stopTime = nil
            }
            
            // If we don't have a time or the time is in the future, this is our current stop
            if let time = stopTime, time > now {
                currentLocation = index > 0 ? trip.route[index-1].location.name : "Departing"
                nextStop = route.location.name
                
                // Calculate percentage based on position in route and time between stops
                if index > 0 && index < totalStops {
                    let previousStopTime: Date?
                    
                    if let prevEstimatedString = trip.route[index-1].arrival.estimated,
                       let prevEstimatedDate = isoFormatter.date(from: prevEstimatedString) {
                        previousStopTime = prevEstimatedDate
                    } else if let prevScheduledDate = isoFormatter.date(from: trip.route[index-1].arrival.scheduled) {
                        previousStopTime = prevScheduledDate
                    } else {
                        previousStopTime = nil
                    }
                    
                    if let prevTime = previousStopTime {
                        let totalDuration = time.timeIntervalSince(prevTime)
                        let elapsedDuration = now.timeIntervalSince(prevTime)
                        let segmentPercentage = max(0, min(1, elapsedDuration / totalDuration))
                        
                        // Calculate overall percentage
                        let basePercentage = Double(index - 1) / Double(totalStops - 1)
                        let segmentSize = 1.0 / Double(totalStops - 1)
                        completedPercentage = basePercentage + (segmentPercentage * segmentSize)
                    } else {
                        completedPercentage = Double(index - 1) / Double(totalStops - 1)
                    }
                }
                
                break
            }
            
            // If we've reached the last stop and it's in the past
            if index == totalStops - 1 {
                currentLocation = route.location.name
                nextStop = "Arrived"
                completedPercentage = 1.0
            }
        }
        
        return (currentLocation, nextStop, completedPercentage)
    }
}
