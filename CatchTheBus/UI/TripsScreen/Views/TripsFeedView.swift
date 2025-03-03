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
    
    enum SortOption {
        case departureTime
        case arrivalTime
    }
    
    @State private var sortOption: SortOption = .departureTime
    
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
                                await viewModel.fetchTrips(from: todayStart, to: todayEnd, context: .pullToRefresh)
                            }
                        }
                    }
                case .loading:
                    tripsListLoaderView
                case .data:
                    tripsList
                        .searchable(text: $viewModel.searchField, placement: .navigationBarDrawer, prompt: "Start typing navigation or destination name...")
                case .error:
                    ContentUnavailableView {
                        Label("Error fetching trips.", systemImage: "exclamationmark.triangle")
                    } actions: {
                        Button("Try Again") {
                            Task {
                                await viewModel.fetchTrips(from: todayStart, to: todayEnd, context: .pullToRefresh)
                            }
                        }
                    }
                }
            }
            .task {
                await viewModel.fetchTrips(from: todayStart, to: todayEnd, context: .initial) 
            }
            .refreshable {
                await viewModel.fetchTrips(from: todayStart, to: todayEnd, context: .pullToRefresh)
            }
        }
        .navigationTitle("All trips for today.")
    }
    
    private var sortedTrips: [AppQuote] {
        let now = Date()
        
        return viewModel.trips.sorted { trip1, trip2 in
            guard let leg1 = trip1.legs.first, let leg2 = trip2.legs.first else {
                return false
            }
            
            // First check if either trip is expired
            let trip1Expired = isExpired(leg: leg1)
            let trip2Expired = isExpired(leg: leg2)
            
            // Non-expired trips should always come before expired trips
            if !trip1Expired && trip2Expired {
                return true
            } else if trip1Expired && !trip2Expired {
                return false
            }
            
            // If both are expired or both are not expired, sort by the selected option
            if sortOption == .departureTime {
                guard let date1 = ISO8601DateFormatter().date(from: leg1.departure.scheduled),
                      let date2 = ISO8601DateFormatter().date(from: leg2.departure.scheduled) else {
                    return false
                }
                return date1 < date2
            } else {
                guard let arrival1 = leg1.arrival, let arrival2 = leg2.arrival,
                      let date1 = ISO8601DateFormatter().date(from: arrival1.scheduled),
                      let date2 = ISO8601DateFormatter().date(from: arrival2.scheduled) else {
                    return false
                }
                return date1 < date2
            }
        }
    }


    
    private func isExpired(leg: AppLeg) -> Bool {
        guard let arrival = leg.arrival,
              let arrivalDate = ISO8601DateFormatter().date(from: arrival.scheduled) else {
            return false
        }
        
        let twoHoursAgo = Calendar.current.date(byAdding: .hour, value: -2, to: Date())!
        return arrivalDate < twoHoursAgo
    }


    
    private var tripsList: some View {
        List {
            ForEach(sortedTrips) { trip in
                if let leg = trip.legs.first {
                    let expired = isExpired(leg: leg)
                    
                    TripRowView(leg: leg)
                        .opacity(expired ? 0.6 : 1.0)
                        .overlay(
                            Group {
                                if expired {
                                    VStack {
                                        Spacer()
                                        HStack {
                                            Spacer()
                                            Text("EXPIRED")
                                                .font(.caption)
                                                .fontWeight(.bold)
                                                .foregroundColor(.white)
                                                .padding(.horizontal, 8)
                                                .padding(.vertical, 4)
                                                .background(Color.red.opacity(0.8))
                                                .cornerRadius(4)
                                            Spacer()
                                        }
                                        Spacer()
                                    }
                                }
                            }
                        )
                        .onTapGesture {
                            if !expired {
                                selectedTripID(leg.tripUid)
                            }
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
