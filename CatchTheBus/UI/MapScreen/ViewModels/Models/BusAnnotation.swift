//
//  BusAnnotation.swift
//  CatchTheBus
//
//  Created by amolonus on 18/02/2025.
//

import SwiftUI
import MapKit

// MARK: - Annotation Wrapper

struct BusAnnotation: Identifiable {
    let id = UUID()
    let bus: Bus
    let coordinate: CLLocationCoordinate2D
}
