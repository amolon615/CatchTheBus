//
//  OnboardingViewModel.swift
//  CatchTheBus
//
//  Created by amolonus on 03/03/2025.
//

import Foundation


final class OnboardingViewModel: ObservableObject {
    
    let features = [
        OnboardingFeature(
            title: "Pick Your Route",
            description: "Choose from a variety of routes to find the one that suits your journey.",
            icon: "map"
        ),
        OnboardingFeature(
            title: "Track in Real-Time",
            description: "Stay updated with real-time timetables and arrival information.",
            icon: "clock.arrow.circlepath"
        ),
        OnboardingFeature(
            title: "Live Activities",
            description: "Get instant updates with Live Activities on your lock screen.",
            icon: "bell.badge"
        )
    ]
    
    func completeOnboarding(appStateManager: AppStateManager) {
        appStateManager.completeOnboarding()
    }
}

struct OnboardingFeature {
    let title: String
    let description: String
    let icon: String
}
