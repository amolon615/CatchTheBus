//
//  CurrentTripView.swift
//  CatchTheBus
//
//  Created by amolonus on 02/03/2025.
//
import SwiftUI

struct CurrentTripView: View {
    @StateObject var viewModel: UITripViewModel
    var body: some View {
        Text("CurrentTripView: \(viewModel.currentTrip?.vehicle.name)")
            .task {
                await viewModel.fetchTripInfo()
            }
    }
}
