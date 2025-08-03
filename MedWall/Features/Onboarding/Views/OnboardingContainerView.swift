// MARK: - Onboarding Container View
// File: MedWall/Features/Onboarding/Views/OnboardingContainerView.swift

import SwiftUI

struct OnboardingContainerView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject var appConfiguration: AppConfiguration
    
    var body: some View {
        TabView(selection: $viewModel.currentStep) {
            WelcomeView()
                .tag(OnboardingStep.welcome)
            
            SpecialtySelectionView(viewModel: viewModel)
                .tag(OnboardingStep.specialtySelection)
            
            DifficultySelectionView(viewModel: viewModel)
                .tag(OnboardingStep.difficultySelection)
            
            ShortcutsSetupView()
                .tag(OnboardingStep.shortcutsSetup)
            
            FirstWallpaperView(viewModel: viewModel)
                .tag(OnboardingStep.firstWallpaper)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .automatic))
        .onReceive(viewModel.$isCompleted) { isCompleted in
            if isCompleted {
                appConfiguration.hasCompletedOnboarding = true
                UserDefaults.standard.set(true, forKey: "HasCompletedOnboarding")
            }
        }
    }
}

enum OnboardingStep: Int, CaseIterable {
    case welcome = 0
    case specialtySelection = 1
    case difficultySelection = 2
    case shortcutsSetup = 3
    case firstWallpaper = 4
}
