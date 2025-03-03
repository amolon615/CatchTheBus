//
//  AppRoot.swift
//  CatchTheBus
//
//  Created by amolonus on 03/03/2025.
//
import SwiftUI

struct AppRoot: View {
    @StateObject var appStateManager: AppStateManager
    
    var body: some View {
        Group {
            switch appStateManager.state {
            case .onboarding:
                onboardingView
                    .transition(.opacity)
                
            case .app:
                rootView
                    .transition(.opacity)
            case .none:
                EmptyView()
            }
        }
        .animation(.easeInOut, value: appStateManager.state)
    }
    
    @ViewBuilder
    private var rootView: some View {
        let viewModel: UIRootCoordinatorViewModel = .init()
        HomeScreen(viewModel: viewModel)
    }
    
    @ViewBuilder
    private var onboardingView: some View {
        let viewModel: OnboardingViewModel = .init()
        OnboardingView(viewModel: viewModel)
    }
    
}
