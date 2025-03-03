//
//  TripsFeedView.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import SwiftUI

import SwiftUI

struct TripsFeedView<ViewModel: TripsFeedViewModel>: View {
    @EnvironmentObject var tripsServer: AppTripsServer
    @StateObject var viewModel: ViewModel
    
    // Sort options enum
    enum SortOption {
        case departureTime
        case arrivalTime
    }
    
    @State private var sortOption: SortOption = .departureTime
    
    // Always use today's date range
    private var todayStart: Date {
        Calendar.current.startOfDay(for: Date())
    }
    
    private var todayEnd: Date {
        Calendar.current.date(byAdding: .day, value: 1, to: todayStart)!
    }
    
    var selectedTripID: (_ trip: String) -> Void
    
    var body: some View {
        VStack {
            Group {
                switch viewModel.state {
                case .idle:
                    tripsList
                case .empty:
                    ContentUnavailableView {
                        Label("No trips available.", systemImage: "magnifyingglass")
                    } actions: {
                        Button("Refresh") {
                            Task {
                                await viewModel.fetchTrips(from: todayStart, to: todayEnd)
                            }
                        }
                    }
                case .loading:
                    tripsListLoaderView
                case .data:
                    tripsList
                case .error:
                    ContentUnavailableView {
                        Label("Error fetching trips.", systemImage: "exclamationmark.triangle")
                    } actions: {
                        Button("Try Again") {
                            Task {
                                await viewModel.fetchTrips(from: todayStart, to: todayEnd)
                            }
                        }
                    }
                }
            }
            .task {
                await viewModel.fetchTrips(from: todayStart, to: todayEnd)
            }
            .refreshable {
                await viewModel.fetchTrips(from: todayStart, to: todayEnd)
            }
        }
        .navigationTitle("All trips for today.")
    }
    
    private var sortedTrips: [AppQuote] {
        switch sortOption {
        case .departureTime:
            return viewModel.trips.sorted { trip1, trip2 in
                guard let leg1 = trip1.legs.first, let leg2 = trip2.legs.first,
                      let date1 = ISO8601DateFormatter().date(from: leg1.departure.scheduled),
                      let date2 = ISO8601DateFormatter().date(from: leg2.departure.scheduled) else {
                    return false
                }
                return date1 < date2
            }
        case .arrivalTime:
            return viewModel.trips.sorted { trip1, trip2 in
                guard let leg1 = trip1.legs.first, let leg2 = trip2.legs.first,
                      let arrival1 = leg1.arrival, let arrival2 = leg2.arrival,
                      let date1 = ISO8601DateFormatter().date(from: arrival1.scheduled),
                      let date2 = ISO8601DateFormatter().date(from: arrival2.scheduled) else {
                    return false
                }
                return date1 < date2
            }
        }
    }
    
    private var tripsList: some View {
        List {
            ForEach(sortedTrips) { trip in
                if let leg = trip.legs.first {
                    TripRowView(leg: leg)
                        .onTapGesture {
                            selectedTripID(leg.tripUid)
                        }
                    Divider()
                        .padding(.horizontal, 10)
                }
            }
            .listRowSeparator(.hidden, edges: .all)
        }
        .listStyle(.plain)
    }
    
    private var tripsListLoaderView: some View {
        List {
            ForEach(Array(repeating: AppQuote.test, count: 10)) { trip in
                TripRowView(leg: .test)
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
