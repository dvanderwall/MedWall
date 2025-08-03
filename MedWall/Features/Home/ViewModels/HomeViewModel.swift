// MARK: - Home ViewModel
// File: MedWall/Features/Home/ViewModels/HomeViewModel.swift

import SwiftUI
import Combine

@MainActor
class HomeViewModel: ObservableObject {
    @Published var currentFact: MedicalFact?
    @Published var currentTheme: WallpaperTheme = WallpaperTheme.defaultThemes[0]
    @Published var recentFacts: [MedicalFact] = []
    @Published var userStats: UserProfile.LearningGoals = UserProfile.LearningGoals()
    @Published var nextReviewTime: Date?
    @Published var isLoading = false
    
    private let contentRepository = ContentRepository.shared
    private let wallpaperGenerator = WallpaperGenerator.shared
    private let spacedRepetitionEngine = SpacedRepetitionEngine.shared
    
    func loadInitialData() async {
        isLoading = true
        defer { isLoading = false }
        
        await loadCurrentFact()
        await loadRecentFacts()
        await loadUserStats()
        calculateNextReviewTime()
    }
    
    func refreshData() async {
        await loadCurrentFact()
        await loadRecentFacts()
    }
    
    func generateNewWallpaper() async {
        guard let newFact = await spacedRepetitionEngine.getNextFactForReview() else { return }
        
        currentFact = newFact
        
        // Generate and set wallpaper
        await wallpaperGenerator.generateAndSetWallpaper(
            fact: newFact,
            theme: currentTheme
        )
        
        // Update spaced repetition
        spacedRepetitionEngine.markFactAsShown(newFact)
    }
    
    private func loadCurrentFact() async {
        currentFact = await spacedRepetitionEngine.getCurrentFact()
    }
    
    private func loadRecentFacts() async {
        recentFacts = await contentRepository.getRecentlyViewedFacts(limit: 5)
    }
    
    private func loadUserStats() async {
        // Load from UserProfile or local storage
        userStats = UserProfile.LearningGoals() // Placeholder
    }
    
    private func calculateNextReviewTime() {
        nextReviewTime = spacedRepetitionEngine.getNextReviewTime()
    }
}
