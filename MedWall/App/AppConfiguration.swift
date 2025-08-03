// MARK: - App Configuration
// File: MedWall/App/AppConfiguration.swift

import SwiftUI
import Combine

@MainActor
class AppConfiguration: ObservableObject {
    @Published var isFirstLaunch: Bool = true {
        didSet {
            Logger.shared.log("AppConfiguration: isFirstLaunch changed to \(isFirstLaunch)")
        }
    }
    @Published var hasCompletedOnboarding: Bool = false {
        didSet {
            Logger.shared.log("AppConfiguration: hasCompletedOnboarding changed to \(hasCompletedOnboarding)")
        }
    }
    @Published var isLoading: Bool = true {
        didSet {
            Logger.shared.log("AppConfiguration: isLoading changed to \(isLoading)")
        }
    }
    
    private let userDefaults = UserDefaults.standard
    private let coreDataStack = CoreDataStack.shared
    
    func initializeApp() {
        checkFirstLaunch()
        loadUserPreferences()
        initializeServices()
        
        Task {
            await setupInitialData()
            await MainActor.run {
                isLoading = false
            }
        }
    }
    
    private func checkFirstLaunch() {
        isFirstLaunch = !userDefaults.bool(forKey: "HasLaunchedBefore")
        hasCompletedOnboarding = userDefaults.bool(forKey: "HasCompletedOnboarding")
        
        if isFirstLaunch {
            userDefaults.set(true, forKey: "HasLaunchedBefore")
        }
        
        Logger.shared.log("App launch check - First launch: \(isFirstLaunch), Onboarding completed: \(hasCompletedOnboarding)")
    }
    
    private func loadUserPreferences() {
        // Load user settings from UserDefaults
        Logger.shared.log("Loading user preferences")
    }
    
    private func initializeServices() {
        // Initialize services
        Logger.shared.log("Initializing services")
        
        // Initialize notification service
        NotificationService.shared.requestPermissions()
        
        // Initialize shortcuts service (temporarily disabled due to intent issues)
        ShortcutsService.shared.setupDefaultShortcuts()
    }
    
    func completeOnboarding() {
        Logger.shared.log("AppConfiguration: Completing onboarding")
        hasCompletedOnboarding = true
        userDefaults.set(true, forKey: "HasCompletedOnboarding")
        userDefaults.synchronize() // Force synchronization
        Logger.shared.log("AppConfiguration: Onboarding completed, saved to UserDefaults")
    }
    
    private func setupInitialData() async {
        // Load initial medical facts if first launch
        if isFirstLaunch {
            Logger.shared.log("Setting up initial data for first launch")
            await ContentRepository.shared.loadInitialFacts()
        }
    }
}
