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
        if let nextStep = OnboardingStep(rawValue: currentStep.rawValue + 1) {
            withAnimation {
                currentStep = nextStep
            }
        } else {
            completeOnboarding()
        }
    }
    
    func previousStep() {
        if let previousStep = OnboardingStep(rawValue: currentStep.rawValue - 1) {
            withAnimation {
                currentStep = previousStep
            }
        }
    }
    
    func completeOnboarding() {
        saveUserPreferences()
        isCompleted = true
    }
    
    private func saveUserPreferences() {
        var userProfile = UserProfile()
        userProfile.selectedSpecialties = selectedSpecialties
        userProfile.preferredDifficulty = selectedDifficulty
        
        if let data = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(data, forKey: "UserProfile")
        }
    }
}
