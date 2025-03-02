//
//  TripsFeedView.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import SwiftUI

struct TripsFeedView<ViewModel: TripsFeedViewModel>: View {
    @EnvironmentObject var tripsServer: AppTripsServer
    @StateObject var viewModel: ViewModel
    
    private var earliestDate: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    private var latestDate: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: Date())!
    }
    
    @State private var fromDate: Date = Calendar.current.startOfDay(for: Date())
    @State private var toDate: Date   = Date()
    
    var selectedTripID: (_ trip: String) -> Void
    
    var body: some View {
        VStack {
            VStack {
                HStack {
                    VStack {
                        Text("From:")
                        DatePicker(
                            "",
                            selection: $fromDate,
                            in: earliestDate...latestDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                    }
                    VStack {
                        Text("To:")
                        DatePicker(
                            "",
                            selection: $toDate,
                            in: fromDate...latestDate,
                            displayedComponents: [.date, .hourAndMinute]
                        )
                    }
                }
                .padding()
                Button {
                    fromDate = Calendar.current.date(byAdding: .hour, value: -2, to: .now)!
                    Task { await viewModel.fetchTrips(from: fromDate, to: toDate)}
                } label: {
                    Text("Most recent")
                }
                
                Button("Fetch Trips") {
                    Task {
                        await viewModel.fetchTrips(from: fromDate, to: toDate)
                    }
                }
            }
            Group {
                switch viewModel.state {
                case .idle:
                    routesList
                case .empty:
                    ContentUnavailableView {
                        Label("No routes available.", systemImage: "magnifyingglass")
                    } actions: {
                    }
                case .loading:
                    routesListLoaderView
                case .data:
                    routesList
                case .error:
                    ContentUnavailableView {
                        Label("Error fetching routes.", systemImage: "exclamationmark.triangle")
                    } actions: {
                    }
                }
            }
            .task {
                await viewModel.fetchTrips(from: fromDate, to: toDate)
            }
            .refreshable {
                await viewModel.fetchTrips(from: fromDate, to: toDate)
            }
        }
    }
    
    private var routesList: some View {
        List {
            ForEach(viewModel.trips) { trip in
                if let trip = trip.legs.first {
                        Text("\(trip.tripUid)")
                        .onTapGesture {
                            selectedTripID(trip.tripUid)
                        }
                }
            }
            .listRowSeparator(.hidden, edges: .all)
        }
        .listStyle(.plain)
    }
    
    private var routesListLoaderView: some View {
        List {
            ForEach(Array(repeating: AppQuote.test, count: 30)) { trip in
                if let trip = trip.legs.first {
                    NavigationLink(value: trip) {
                        Text("\(trip.tripUid)")
                    }
                }
            }
            .listRowSeparator(.hidden, edges: .all)
        }
        .listStyle(.plain)
        .redacted(reason: .placeholder)
        .allowsHitTesting(false)
    }
}



struct TripsFeedView_Previews: PreviewProvider {
    static var previews: some View {
        ForEach(TripsFeedViewModelState.allCases, id: \.self) { state in
            TripsFeedView(viewModel: MockTripsFeedViewModel(state: state), selectedTripID: {_ in})
                .previewDisplayName(state.title)
        }
    }
}
