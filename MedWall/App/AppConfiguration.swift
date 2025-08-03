// MARK: - App Configuration
// File: MedWall/App/AppConfiguration.swift

import SwiftUI
import Combine

@MainActor
class AppConfiguration: ObservableObject {
    @Published var isFirstLaunch: Bool = true
    @Published var hasCompletedOnboarding: Bool = false
    @Published var isLoading: Bool = true
    
    private let userDefaults = UserDefaults.standard
    private let coreDataStack = CoreDataStack.shared
    
    func initializeApp() {
        checkFirstLaunch()
        loadUserPreferences()
        initializeServices()
        
        Task {
            await setupInitialData()
            isLoading = false
        }
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !userDefaults.bool(forKey: "HasLaunchedBefore")
        hasCompletedOnboarding = userDefaults.bool(forKey: "HasCompletedOnboarding")
        
        if isFirstLaunch {
            userDefaults.set(true, forKey: "HasLaunchedBefore")
        }
    }
    
    private func loadUserPreferences() {
        // Load user settings from UserDefaults
    }
    
    private func initializeServices() {
        // Initialize Firebase services, notifications, etc.
        NotificationService.shared.requestPermissions()
        ShortcutsService.shared.setupDefaultShortcuts()
    }
    
    private func setupInitialData() async {
        // Load initial medical facts if first launch
        if isFirstLaunch {
            await ContentRepository.shared.loadInitialFacts()
        }
    }
}
