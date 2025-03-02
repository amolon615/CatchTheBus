//
//  CurrentTripView.swift
//  CatchTheBus
//
//  Created by amolonus on 02/03/2025.
//
import SwiftUI
import MapKit

struct CurrentTripView: View {
    @StateObject var viewModel: UITripViewModel
    @EnvironmentObject private var networkObserver: NetworkObserver
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @State private var isShowingTimetable: Bool = true
    @State private var mapStandardMode: Bool = false
    @State private var showDetailsView: Bool = false
    
    var busAnnotation: BusAnnotation? {
        guard let vehicle = viewModel.currentTrip?.vehicle else { return nil }
        return BusAnnotation(
            id: vehicle.id,
            coordinate: CLLocationCoordinate2D(latitude: vehicle.gps.latitude, longitude: vehicle.gps.longitude),
            heading: vehicle.gps.heading
        )
    }
    
    var mapAnnotations: [MapAnnotationItem] {
        var items: [MapAnnotationItem] = []
        if let bus = busAnnotation {
            items.append(.bus(bus))
        }
        if let trip = viewModel.currentTrip {
            items.append(contentsOf: trip.route.map { .stop($0) })
        }
        return items
    }
    
    var stopTracking: () -> Void
    
    var body: some View {
        NavigationStack {
            mapView
                .overlay(alignment: .top, content: {
                    offlineIndicatorView
                })
                .sheet(isPresented: .constant(true)) {
                    tripTimeTableView
                }
                .task {
                    viewModel.startUpdatingTripInfo()
                }
                .onReceive(viewModel.$currentTrip) { trip in
                    guard let trip else { return }
                    region.center = CLLocationCoordinate2D(latitude: trip.vehicle.gps.latitude, longitude: trip.vehicle.gps.longitude)
                }
        }
    }
    
    @ViewBuilder
    private var tripTitle: some View {
        HStack {
            Image("emberBus")
                .resizable()
                .scaledToFit()
                .frame(width: 75, height: 75)
                .clipShape(RoundedRectangle(cornerRadius: 10, style: .continuous))
                .padding(.horizontal, 5)
            VStack(alignment: .leading) {
                HStack {
                    Group {
                        Text("Route \(viewModel.currentTrip?.description.routeNumber ?? "E95")") +
                        Text("-") +
                        Text(formatCalendarDate(viewModel.currentTrip?.description.calendarDate ?? ""))
                    }
                    .foregroundStyle(Color.secondary)
                    .font(.caption)
                }
                if let departureName = viewModel.currentTrip?.route.first?.location.regionName,
                   let arrivalName = viewModel.currentTrip?.route.last?.location.regionName {
                    Group {
                        Text(departureName) + Text(" to ") + Text(arrivalName)
                    }
                    .font(.subheadline)
                    .bold()
                }
                Text("Plate number \(viewModel.currentTrip?.vehicle.plateNumber ?? "N/A")")
                    .foregroundStyle(Color.secondary)
                    .font(.caption)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    @ViewBuilder
    private var tripTimeTableView: some View {
        NavigationStack {
            ScrollView {
                VStack {
                    tripTitle
                    timeTableView
                }
            }
            .interactiveDismissDisabled()
            .presentationDetents([.fraction(0.3), .medium, .large])
            .navigationTitle("My trip")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            mapStandardMode.toggle()
                        }
                    } label: {
                        Image(systemName: mapStandardMode ? "map.fill" : "globe.europe.africa.fill")
                            .font(.system(size: 22))
                    }
                    .contentTransition(.symbolEffect(.replace))
                }
                
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        withAnimation {
                            showDetailsView.toggle()
                        }
                    } label: {
                        Image(systemName: "info.circle.fill")
                            .font(.system(size: 22))
                    }
                    .contentTransition(.symbolEffect(.replace))
                }
                
                
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        stopTracking()
                    } label: {
                        Image(systemName: "xmark.circle.fill")
                            .font(.system(size: 22))
                            .tint(Color.red.opacity(0.7))
                    }
                }
            }
        }
    }
    
    @ViewBuilder
    private var mapView: some View {
        Map(coordinateRegion: $region, interactionModes: .all, annotationItems: mapAnnotations) { item in
            MapAnnotation(coordinate: item.coordinate) {
                switch item {
                case .bus(let bus):
                    RoundedRectangle(cornerRadius: 5)
                        .fill(LinearGradient(colors: [Color(hex: 0x329379), Color(hex: 0x7DB8A5)], startPoint: .bottom, endPoint: .top))
                        .overlay { RoundedRectangle(cornerRadius: 5, style: .continuous).stroke(Color.white, lineWidth: 1)}
                        .frame(width: 15, height: 30)
                        .rotationEffect(.degrees(bus.heading))
                case .stop:
                    Circle().fill(Color.red).frame(width: 10, height: 10)
                }
            }
        }
        .mapStyle(mapStandardMode ? .standard : .imagery)
    }
    
    @ViewBuilder
    private var timeTableView: some View {
        if let currentTrip = viewModel.currentTrip {
            // Find the current stop index
            let currentStopIndex = getCurrentStopIndex(in: currentTrip)
            
            ForEach(Array(currentTrip.route.enumerated()), id:\.element.id) { index, route in
                VStack {
                    HStack {
                        // Route line shapes (rectangles)
                        Group {
                            switch index {
                            case 0:
                                UnevenRoundedRectangle(topLeadingRadius: 25, bottomLeadingRadius: 0, bottomTrailingRadius: 0, topTrailingRadius: 25, style: .continuous)
                                    .frame(maxHeight: .infinity)
                                    .frame(width: 20)
                                    .foregroundStyle(index < currentStopIndex ? Color.gray : Color.accentColor)
                                    .padding(.leading, 10)
                                    .padding(.vertical, -10)
                            case currentTrip.route.count - 1:
                                UnevenRoundedRectangle(topLeadingRadius: 0, bottomLeadingRadius: 25, bottomTrailingRadius: 25, topTrailingRadius: 0, style: .continuous)
                                    .frame(maxHeight: .infinity)
                                    .frame(width: 20)
                                    .foregroundStyle(index < currentStopIndex ? Color.gray : Color.accentColor)
                                    .padding(.leading, 10)
                                    .padding(.vertical, -10)
                            default:
                                Rectangle()
                                    .frame(maxHeight: .infinity)
                                    .frame(width: 20)
                                    .foregroundStyle(index < currentStopIndex ? Color.gray : Color.accentColor)
                                    .padding(.leading, 10)
                                    .padding(.vertical, -10)
                            }
                        }
                        .overlay(alignment: .bottom) {
                            if shouldShowBusIndicator(at: index, in: currentTrip) {
                                Image(systemName: "bus.fill")
                                    .font(.system(size: 20))
                                    .foregroundColor(Color.accentColor)
                                    .background {
                                        Circle()
                                            .fill(Color.white.opacity(0.7))
                                    }
                                    .padding(.leading, 10)
                            }
                        }
                        
                        
                        switch index {
                            //Departure stop
                        case 0:
                            HStack {
                                Text("\(route.location.name)")
                                    .padding(.leading, 5)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(index < currentStopIndex ? Color.gray : Color.primary)
                                timeProperties(for: route.arrival)
                                    .padding(.trailing, 5)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .foregroundColor(index < currentStopIndex ? Color.gray : Color.primary)
                            }
                            .padding(.horizontal, 5)
                            .frame(maxWidth: .infinity)
                            Divider()
                                .padding(.horizontal, 5)
                            //Arrival stop
                        case currentTrip.route.count - 1:
                            HStack {
                                Text("\(route.location.name)")
                                    .padding(.leading, 5)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(index < currentStopIndex ? Color.gray : Color.primary)
                                timeProperties(for: route.arrival)
                                    .padding(.trailing, 5)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .foregroundColor(index < currentStopIndex ? Color.gray : Color.primary)
                            }
                            .padding(.horizontal, 5)
                            .frame(maxWidth: .infinity)
                            Divider()
                                .padding(.horizontal, 5)
                            //All the others
                        default:
                            HStack {
                                Text("\(route.location.name)")
                                    .padding(.leading, 5)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                    .foregroundColor(index < currentStopIndex ? Color.gray : Color.primary)
                                timeProperties(for: route.arrival)
                                    .padding(.trailing, 5)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .foregroundColor(index < currentStopIndex ? Color.gray : Color.primary)
                            }
                            .padding(.horizontal, 5)
                            .frame(maxWidth: .infinity)
                            Divider()
                                .padding(.horizontal, 5)
                        }
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
    
    @ViewBuilder
    private var offlineIndicatorView: some View {
        if !networkObserver.isConnected {
            Text("Offline mode. Map data may not be up to date.")
                .foregroundStyle(Color.white)
                .padding()
                .background(.thickMaterial, in: Capsule())
                .padding(.top, 10)
            
        }
    }
    
    @ViewBuilder
    private func timeProperties(for schedule: AppScheduleModel) -> some View {
        Group {
            let isoFormatter = ISO8601DateFormatter()
            let timeFormatter: DateFormatter = {
                let formatter = DateFormatter()
                formatter.dateFormat = "HH:mm"
                return formatter
            }()
            
            if let scheduledDate = isoFormatter.date(from: schedule.scheduled) {
                if let estimatedString = schedule.estimated,
                   let estimatedDate = isoFormatter.date(from: estimatedString) {
                    // Both Scheduled and Estimated are available
                    let scheduledTimeString = timeFormatter.string(from: scheduledDate)
                    let estimatedTimeString = timeFormatter.string(from: estimatedDate)
                    
                    // Calculate time difference in minutes
                    let timeDifference = estimatedDate.timeIntervalSince(scheduledDate)
                    let minutesDifference = Int(timeDifference / 60)
                    
                    VStack {
                        if minutesDifference < 0 {
                            Text("Scheduled: \(scheduledTimeString)")
                            Text("Estimated: \(estimatedTimeString)")
                            Text("^[\(-minutesDifference) minute](inflect: true) earlier")
                                .foregroundColor(.green)
                        } else if minutesDifference > 0 {
                            Text("Scheduled: \(scheduledTimeString)")
                                .foregroundStyle(Color.red)
                                .strikethrough(true, color: .red)
                            Text("Estimated: \(estimatedTimeString)")
                            Text("^[\(minutesDifference) minute](inflect: true) later")
                                .foregroundColor(.red)
                        } else {
                            Text("Scheduled: \(scheduledTimeString)")
                            Text("Estimated: \(estimatedTimeString)")
                            Text("On time")
                                .foregroundColor(.blue)
                        }
                    }
                } else {
                    // Only scheduled time is available
                    let scheduledTimeString = timeFormatter.string(from: scheduledDate)
                    Text("Scheduled: \(scheduledTimeString)")
                }
            } else {
                Text("Invalid date")
            }
        }
    }
    
    private func formatCalendarDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        if let date = dateFormatter.date(from: dateString) {
            dateFormatter.dateFormat = "EEE, d MMM"
            
            return dateFormatter.string(from: date)
        }
        return dateString
    }
    
    private func shouldShowBusIndicator(at index: Int, in trip: AppTripModel) -> Bool {
        let now = Date()
        let isoFormatter = ISO8601DateFormatter()
        
        // Get current stop and next stop times
        let currentRoute = trip.route[index]
        let currentStopTime: Date?
        
        // Use estimated time if available, otherwise use scheduled
        if let estimatedString = currentRoute.arrival.estimated,
           let estimatedDate = isoFormatter.date(from: estimatedString) {
            currentStopTime = estimatedDate
        } else if let scheduledDate = isoFormatter.date(from: currentRoute.arrival.scheduled) {
            currentStopTime = scheduledDate
        } else {
            currentStopTime = nil
        }
        
        // If this is the last stop, only show bus if we're close to or past arrival time
        if index == trip.route.count - 1 {
            guard let arrivalTime = currentStopTime else { return false }
            // Show bus at final stop if we're within 5 minutes of arrival or have passed it
            let timeUntilArrival = arrivalTime.timeIntervalSince(now)
            return timeUntilArrival <= 5 * 60 // 5 minutes in seconds
        }
        
        // For stops in between, check if we're between this stop and the next
        guard let thisStopTime = currentStopTime,
              index + 1 < trip.route.count else { return false }
        
        let nextRoute = trip.route[index + 1]
        let nextStopTime: Date?
        
        if let estimatedString = nextRoute.arrival.estimated,
           let estimatedDate = isoFormatter.date(from: estimatedString) {
            nextStopTime = estimatedDate
        } else if let scheduledDate = isoFormatter.date(from: nextRoute.arrival.scheduled) {
            nextStopTime = scheduledDate
        } else {
            nextStopTime = nil
        }
        
        guard let nextTime = nextStopTime else { return false }
        
        // Show bus if current time is between this stop and the next stop
        return now >= thisStopTime && now < nextTime
    }
    
    private func getCurrentStopIndex(in trip: AppTripModel) -> Int {
        let now = Date()
        let isoFormatter = ISO8601DateFormatter()
        
        for (index, route) in trip.route.enumerated() {
            // Get the time for this stop
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
                return index
            }
        }
        
        // If all stops are in the past, return the last stop index
        return trip.route.count
    }
}
