//
//  AppGlobalState.swift
//  CatchTheBus
//
//  Created by amolonus on 03/03/2025.
//
import SwiftUI

final class AppStateManager: ObservableObject {
    @Published var state: AppGlobalState?
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding: Bool = false
    
    init() {
        self.state = hasCompletedOnboarding ? .app : .onboarding
    }
    
    func completeOnboarding() {
        hasCompletedOnboarding = true
        withAnimation(.easeInOut) {
            state = .app
        }
    }
    
    func resetOnboarding() {
        // For testing purposes
        hasCompletedOnboarding = false
        withAnimation(.easeInOut) {
            state = .onboarding
        }
    }
}
