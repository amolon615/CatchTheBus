//
//  TripsFeedViewModelState.swift
//  CatchTheBus
//
//  Created by amolonus on 01/03/2025.
//
import Foundation

enum TripsFeedViewModelState: String, CaseIterable {
    case idle
    case empty
    case loading
    case data
    case error
    
    var title: String {
        switch self {
        case .idle:
            "Idle"
        case .empty:
            "Empty"
        case .loading:
            "Loading"
        case .data:
            "Data"
        case .error:
            "Error"
        }
    }
}
