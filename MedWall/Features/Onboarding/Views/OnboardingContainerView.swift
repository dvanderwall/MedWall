// MARK: - Onboarding Container View
// File: MedWall/Features/Onboarding/Views/OnboardingContainerView.swift

import SwiftUI

struct OnboardingContainerView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    @EnvironmentObject var appConfiguration: AppConfiguration
    
    var body: some View {
        VStack {
            // Progress indicator
            HStack {
                ForEach(OnboardingStep.allCases, id: \.self) { step in
                    Circle()
                        .fill(step.rawValue <= viewModel.currentStep.rawValue ? Color.blue : Color.gray.opacity(0.3))
                        .frame(width: 8, height: 8)
                    
                    if step != OnboardingStep.allCases.last {
                        Rectangle()
                            .fill(step.rawValue < viewModel.currentStep.rawValue ? Color.blue : Color.gray.opacity(0.3))
                            .frame(height: 2)
                    }
                }
            }
            .padding(.horizontal)
            .padding(.top)
            
            // Content
            TabView(selection: $viewModel.currentStep) {
                WelcomeView()
                    .tag(OnboardingStep.welcome)
                    .onTapGesture {
                        viewModel.nextStep()
                    }
                
                SpecialtySelectionView(viewModel: viewModel)
                    .tag(OnboardingStep.specialtySelection)
                
                DifficultySelectionView(viewModel: viewModel)
                    .tag(OnboardingStep.difficultySelection)
                
                ShortcutsSetupView(viewModel: viewModel)
                    .tag(OnboardingStep.shortcutsSetup)
                
                FirstWallpaperView(viewModel: viewModel)
                    .tag(OnboardingStep.firstWallpaper)
            }
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            .animation(.easeInOut(duration: 0.3), value: viewModel.currentStep)
        }
        .onReceive(viewModel.$isCompleted) { isCompleted in
            if isCompleted {
                appConfiguration.hasCompletedOnboarding = true
                UserDefaults.standard.set(true, forKey: "HasCompletedOnboarding")
            }
        }
    }
}
