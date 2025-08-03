// MARK: - Onboarding ViewModel
// File: MedWall/Features/Onboarding/ViewModels/OnboardingViewModel.swift

import SwiftUI

@MainActor
class OnboardingViewModel: ObservableObject {
    @Published var currentStep: OnboardingStep = .welcome
    @Published var selectedSpecialties: Set<MedicalFact.Specialty> = []
    @Published var selectedDifficulty: MedicalFact.Difficulty = .resident
    @Published var isCompleted = false
    
    func nextStep() {
        withAnimation(.easeInOut(duration: 0.3)) {
            switch currentStep {
            case .welcome:
                currentStep = .specialtySelection
            case .specialtySelection:
                currentStep = .difficultySelection
            case .difficultySelection:
                currentStep = .shortcutsSetup
            case .shortcutsSetup:
                currentStep = .firstWallpaper
            case .firstWallpaper:
                completeOnboarding()
            }
        }
    }
    
    func previousStep() {
        withAnimation(.easeInOut(duration: 0.3)) {
            switch currentStep {
            case .welcome:
                break // Can't go back from welcome
            case .specialtySelection:
                currentStep = .welcome
            case .difficultySelection:
                currentStep = .specialtySelection
            case .shortcutsSetup:
                currentStep = .difficultySelection
            case .firstWallpaper:
                currentStep = .shortcutsSetup
            }
        }
    }
    
    func completeOnboarding() {
        Logger.shared.log("OnboardingViewModel: Starting completion")
        saveUserPreferences()
        
        withAnimation(.easeInOut(duration: 0.5)) {
            isCompleted = true
        }
        
        Logger.shared.log("OnboardingViewModel: Completion finished, isCompleted = \(isCompleted)")
    }
    
    // Public method to allow external classes to save preferences
    func saveUserPreferencesPublic() {
        saveUserPreferences()
    }
    
    private func saveUserPreferences() {
        var userProfile = UserProfile()
        userProfile.selectedSpecialties = selectedSpecialties
        userProfile.preferredDifficulty = selectedDifficulty
        
        do {
            let data = try JSONEncoder().encode(userProfile)
            UserDefaults.standard.set(data, forKey: "UserProfile")
            Logger.shared.log("User preferences saved successfully")
        } catch {
            Logger.shared.log("Failed to save user preferences: \(error)", level: .error)
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
