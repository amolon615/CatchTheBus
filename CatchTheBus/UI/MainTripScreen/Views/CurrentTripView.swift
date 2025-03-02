//
//  CurrentTripView.swift
//  CatchTheBus
//
//  Created by amolonus on 02/03/2025.
//
import SwiftUI
import MapKit

@MainActor
final class UITripViewModel: ObservableObject {
    let tripID: String
    let tripsServer: AppTripsServer
    
    @Published var currentTrip: AppTripModel?
    private var updateTask: Task<Void, Never>?
    
    init(tripID: String, tripsServer: AppTripsServer) {
        self.tripID = tripID
        self.tripsServer = tripsServer
    }
    
    func fetchTripInfo() async {
        do {
            currentTrip = try await tripsServer.fetchOneTrip(withID: tripID)
        } catch let error {
            print("Error loading trip details: \(error.localizedDescription)")
        }
    }
    
    func startUpdatingTripInfo() {
        updateTask?.cancel()
        updateTask = Task {
            while !Task.isCancelled {
                await fetchTripInfo()
                try? await Task.sleep(nanoseconds: 2_000_000_000)
            }
        }
    }
    
    deinit {
        updateTask?.cancel()
    }
}


struct BusAnnotation: Identifiable {
    let id: Int
    let coordinate: CLLocationCoordinate2D
    let heading: Double
}

enum MapAnnotationItem: Identifiable {
    case bus(BusAnnotation)
    case stop(AppRouteModel)
    
    var id: String {
        switch self {
        case .bus(let bus):
            return "bus-\(bus.id)"
        case .stop(let route):
            return "stop-\(route.id)"
        }
    }
    
    var coordinate: CLLocationCoordinate2D {
        switch self {
        case .bus(let bus):
            return bus.coordinate
        case .stop(let route):
            return CLLocationCoordinate2D(latitude: route.location.lat, longitude: route.location.lon)
        }
    }
}

struct CurrentTripView: View {
    @StateObject var viewModel: UITripViewModel
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.7749, longitude: -122.4194),
        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
    )
    
    @State private var isShowingSheet: Bool = true
    
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
    
    @State private var mapStandardMode: Bool = false
    
    @State private var showShareView: Bool = false
    @State private var showAccountView: Bool = false
    
    
    var body: some View {
        NavigationStack {
            ZStack {
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
                VStack {
                    Text("Bus: \(viewModel.currentTrip?.vehicle.name ?? "Loading...")")
                        .padding()
                    Spacer()
                }
            }
            .sheet(isPresented: .constant(true)) {
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
                            Button {} label: {
                                Image(systemName: "square.and.arrow.up.fill")
                                    .font(.system(size: 22))
                            }
                            .contentTransition(.symbolEffect(.replace))
                        }
                        
                        ToolbarItem(placement: .topBarLeading) {
                            Button { } label: {
                                Image(systemName: "person.circle.fill")
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
    
    private func formatCalendarDate(_ dateString: String) -> String {
        let dateFormatter = DateFormatter()
        
        // Set the input date format
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        // Convert string to Date
        if let date = dateFormatter.date(from: dateString) {
            // Set the output date format
            dateFormatter.dateFormat = "EEE, d MMM"
            
            // Convert Date to the desired string format
            return dateFormatter.string(from: date)
        }
        
        return dateString // Return original string if formatting fails
    }
    
    @ViewBuilder
    private var timeTableView: some View {
        if let currentTrip = viewModel.currentTrip {
                ForEach(Array(currentTrip.route.enumerated()), id:\.element.id) { index, route in
                    VStack {
                        switch index {
                            //Departure stop
                        case 0:
                            HStack {
                                Text("\(route.location.name)")
                                    .padding(.leading, 5)
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                timeProperties(for: route.arrival)
                                    .padding(.trailing, 5)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
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
                                timeProperties(for: route.arrival)
                                    .padding(.trailing, 5)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
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
                                timeProperties(for: route.arrival)
                                    .padding(.trailing, 5)
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                            }
                            .padding(.horizontal, 5)
                            .frame(maxWidth: .infinity)
                            Divider()
                                .padding(.horizontal, 5)
                        }
                    }
                }
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
                            Text("\(-minutesDifference) minutes earlier")
                                .foregroundColor(.green)
                        } else if minutesDifference > 0 {
                            Text("Scheduled: \(scheduledTimeString)")
                                .foregroundStyle(Color.red)
                                .strikethrough(true, color: .red)
                            Text("Estimated: \(estimatedTimeString)")
                            Text("\(minutesDifference) minutes later")
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
}
