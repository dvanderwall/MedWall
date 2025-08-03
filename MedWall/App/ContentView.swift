// MARK: - Root Content View
// File: MedWall/App/ContentView.swift

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appConfiguration: AppConfiguration
    
    var body: some View {
        Group {
            if appConfiguration.isLoading {
                LoadingView()
            } else if !appConfiguration.hasCompletedOnboarding {
                OnboardingContainerView()
            } else {
                MainTabView()
            }
        }
        .animation(.easeInOut(duration: 0.3), value: appConfiguration.isLoading)
        .animation(.easeInOut(duration: 0.3), value: appConfiguration.hasCompletedOnboarding)
    }
}
