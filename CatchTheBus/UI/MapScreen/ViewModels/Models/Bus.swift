//
//  Bus.swift
//  CatchTheBus
//
//  Created by amolonus on 18/02/2025.
//


import SwiftUI
import MapKit
import Combine

struct Bus: Identifiable, Codable {
    let id: Int
    let plate_number: String
    let has_wifi: Bool
    let has_toilet: Bool
    let type: String
    let brand: String
    let colour: String
    let gps: GPS?
}

extension Bus: Equatable {}
