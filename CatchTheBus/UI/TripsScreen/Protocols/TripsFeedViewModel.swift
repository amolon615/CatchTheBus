//
//  TripsFeedViewModel.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

@MainActor
protocol TripsFeedViewModel: Sendable, ObservableObject {
    var trips: [AppQuote] { get }
    var state: TripsFeedViewModelState { get }
    
    func fetchTrips(from: Date, to: Date) async
}
