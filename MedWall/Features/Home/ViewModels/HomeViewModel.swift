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
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupNotificationObservers()
    }
    
    func loadInitialData() async {
        isLoading = true
        defer {
            Task { @MainActor in
                isLoading = false
            }
        }
        
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
        Logger.shared.log("Starting wallpaper generation")
        
        do {
            // Get next fact for review
            guard let newFact = await spacedRepetitionEngine.getNextFactForReview() else {
                Logger.shared.log("No facts available for wallpaper generation", level: .error)
                return
            }
            
            currentFact = newFact
            Logger.shared.log("Selected fact for wallpaper: \(newFact.content.prefix(50))...")
            
            // Generate and set wallpaper
            await wallpaperGenerator.generateAndSetWallpaper(
                fact: newFact,
                theme: currentTheme
            )
            
            // Update spaced repetition
            spacedRepetitionEngine.markFactAsShown(newFact)
            
            // Refresh recent facts
            await loadRecentFacts()
            
            Logger.shared.log("Wallpaper generation completed successfully")
            
        } catch {
            Logger.shared.log("Error generating wallpaper: \(error)", level: .error)
        }
    }
    
    private func setupNotificationObservers() {
        NotificationCenter.default.publisher(for: .wallpaperUpdateRequested)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                Task {
                    await self?.generateNewWallpaper()
                }
            }
            .store(in: &cancellables)
    }
    
    private func loadCurrentFact() async {
        if currentFact == nil {
            currentFact = await spacedRepetitionEngine.getCurrentFact()
            
            // If still no current fact, load a random one
            if currentFact == nil {
                let allFacts = await contentRepository.getAllFacts()
                currentFact = allFacts.randomElement()
            }
        }
    }
    
    private func loadRecentFacts() async {
        recentFacts = await contentRepository.getRecentlyViewedFacts(limit: 5)
    }
    
    private func loadUserStats() async {
        // Load from UserProfile or local storage
        if let data = UserDefaults.standard.data(forKey: "UserProfile"),
           let userProfile = try? JSONDecoder().decode(UserProfile.self, from: data) {
            userStats = userProfile.learningGoals
        } else {
            userStats = UserProfile.LearningGoals()
        }
    }
    
    private func calculateNextReviewTime() {
        nextReviewTime = spacedRepetitionEngine.getNextReviewTime()
    }
}
