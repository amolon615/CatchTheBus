//
//  BusAnnotation.swift
//  CatchTheBus
//
//  Created by amolonus on 02/03/2025.
//
import Foundation
import MapKit

struct BusAnnotation: Identifiable {
    let id: Int
    let coordinate: CLLocationCoordinate2D
    let heading: Double
}
