//
//  OnboardingView.swift
//  CatchTheBus
//
//  Created by amolonus on 03/03/2025.
//

import SwiftUI

struct OnboardingView: View {
    @StateObject  var viewModel: OnboardingViewModel
    @EnvironmentObject private var appStateManager: AppStateManager
    @Namespace private var animation
    
    var body: some View {
        VStack(spacing: 0) {
            // Header image
            Image("emberBus")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(maxWidth: .infinity)
                .frame(height: UIScreen.main.bounds.height * 0.4)
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [Color.blue.opacity(0.7), Color.purple.opacity(0.5)]),
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
                .matchedGeometryEffect(id: "emberBusImage", in: animation)
                .overlay(
                    VStack {
                        Spacer()
                        Text("Travel with Ember")
                            .font(.system(size: 36, weight: .bold))
                            .foregroundColor(.white)
                            .shadow(radius: 2)
                            .padding(.bottom, 30)
                    }
                )
            
            VStack(alignment: .leading, spacing: 30) {
                Text("Welcome Aboard!")
                    .font(.title)
                    .fontWeight(.bold)
                    .padding(.top, 30)
                
                ForEach(viewModel.features, id: \.title) { feature in
                    FeatureRow(feature: feature)
                }
                
                Spacer()
                
                Button {
                    viewModel.completeOnboarding(appStateManager: appStateManager)
                } label: {
                    Text("Get Started")
                        .fontWeight(.bold)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .cornerRadius(12)
                        .shadow(radius: 2)
                }
                .padding(.bottom, 30)
            }
            .padding(.horizontal, 20)
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .leading)
            .background(Color(.systemBackground))
            .cornerRadius(30, corners: [.topLeft, .topRight])
            .offset(y: -30)
        }
        .ignoresSafeArea(edges: .top)
        .background(Color.blue.opacity(0.1))
    }
}

struct FeatureRow: View {
    let feature: OnboardingFeature
    
    var body: some View {
        HStack(alignment: .top, spacing: 15) {
            Image(systemName: feature.icon)
                .font(.system(size: 28))
                .foregroundColor(.blue)
                .frame(width: 40, height: 40)
                .background(Color.blue.opacity(0.1))
                .clipShape(Circle())
                .padding(.top, 2)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(feature.title)
                    .font(.headline)
                    .fontWeight(.bold)
                
                Text(feature.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}

// Helper extension for rounded specific corners
extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
