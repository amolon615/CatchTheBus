//
//  GPS.swift
//  CatchTheBus
//
//  Created by amolonus on 18/02/2025.
//


import SwiftUI
import MapKit
import Combine

struct GPS: Codable {
    let latitude: Double
    let longitude: Double
    let heading: Double?
    let last_updated: String
}

extension GPS: Equatable {}
