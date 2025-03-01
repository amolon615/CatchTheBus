//
//  CatchTheBusApp.swift
//  CatchTheBus
//
//  Created by amolonus on 18/02/2025.
//

import SwiftUI

final class AppDependencies: ObservableObject {
    let httpClient: HttpClient

    let tripServer: AppTripsServer

    init() {
        self.httpClient = HttpClient()
        self.tripServer = .init(httpClient: httpClient)
    }
}


@main
struct CatchTheBusApp: App {
    let httpClient = HttpClient()
    private let appDependencies = AppDependencies()
    
    init() {
        loadRocketSimConnect()
    }
    
    var body: some Scene {
        WindowGroup {
            tripsFeed
                .environmentObject(appDependencies)
                .environmentObject(appDependencies.tripServer)
        }
    }
    
    @ViewBuilder
    private var tripsFeed: some View {
        let viewModel: UITripsFeedViewModel = .init(server: appDependencies.tripServer)
        TripsFeedView(viewModel: viewModel)
            .environmentObject(appDependencies)
    }
    
    private func loadRocketSimConnect() {
        #if DEBUG
        guard (Bundle(path: "/Applications/RocketSim.app/Contents/Frameworks/RocketSimConnectLinker.nocache.framework")?.load() == true) else {
            print("Failed to load linker framework")
            return
        }
        print("RocketSim Connect successfully linked")
        #endif
    }
}
