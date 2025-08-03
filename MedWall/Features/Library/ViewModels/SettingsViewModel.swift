// MARK: - Settings ViewModel
// File: MedWall/Features/Library/ViewModels/SettingsViewModel.swift

import SwiftUI
import StoreKit

@MainActor
class SettingsViewModel: ObservableObject {
    @Published var userProfile = UserProfile()
    @Published var backgroundUpdatesEnabled = true
    @Published var notificationsEnabled = true
    @Published var selectedTheme = WallpaperTheme.defaultThemes[0]
    
    var appVersion: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0.0"
    }
    
    private let shortcutsService = ShortcutsService.shared
    private let notificationService = NotificationService.shared
    
    func loadSettings() {
        // Load user preferences from storage
        loadUserProfile()
        loadAppSettings()
    }
    
    func saveSettings() {
        saveUserProfile()
        saveAppSettings()
    }
    
    func setupShortcuts() {
        shortcutsService.setupDefaultShortcuts()
    }
    
    func requestAppStoreReview() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    func sendFeedback() {
        // Simplified version without MessageUI dependency
        let email = "feedback@medwall.app"
        if let url = URL(string: "mailto:\(email)") {
            UIApplication.shared.open(url)
        }
    }
    
    private func loadUserProfile() {
        if let data = UserDefaults.standard.data(forKey: "UserProfile"),
           let profile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            userProfile = profile
        }
    }
    
    private func saveUserProfile() {
        if let data = try? JSONEncoder().encode(userProfile) {
            UserDefaults.standard.set(data, forKey: "UserProfile")
        }
    }
    
    private func loadAppSettings() {
        backgroundUpdatesEnabled = UserDefaults.standard.bool(forKey: "BackgroundUpdatesEnabled")
        notificationsEnabled = UserDefaults.standard.bool(forKey: "NotificationsEnabled")
    }
    
    private func saveAppSettings() {
        UserDefaults.standard.set(backgroundUpdatesEnabled, forKey: "BackgroundUpdatesEnabled")
        UserDefaults.standard.set(notificationsEnabled, forKey: "NotificationsEnabled")
    }
}
