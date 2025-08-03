// MARK: - Statistics ViewModel
// File: MedWall/Features/Statistics/ViewModels/StatisticsViewModel.swift

import SwiftUI
import Combine

@MainActor
class StatisticsViewModel: ObservableObject {
    @Published var currentStreak: Int = 0
    @Published var totalFactsLearned: Int = 0
    @Published var averageRetention: Double = 0.0
    @Published var factsADueForReview: Int = 0
    
    @Published var progressData: [ProgressDataPoint] = []
    @Published var specialtyStats: [SpecialtyStatistic] = []
    @Published var achievements: [Achievement] = []
    
    private let spacedRepetitionEngine = SpacedRepetitionEngine.shared
    private let contentRepository = ContentRepository.shared
    
    struct ProgressDataPoint: Identifiable {
        let id = UUID()
        let date: Date
        let factsLearned: Int
        let retention: Double
    }
    
    struct SpecialtyStatistic {
        let specialty: MedicalFact.Specialty
        let factsLearned: Int
        let totalFacts: Int
        
        var progress: Double {
            guard totalFacts > 0 else { return 0 }
            return Double(factsLearned) / Double(totalFacts)
        }
    }
    
    func loadData() async {
        await loadBasicStats()
        await loadProgressData()
        await loadSpecialtyStats()
        loadAchievements()
    }
    
    func refreshData() async {
        await loadData()
    }
    
    private func loadBasicStats() async {
        let reviewStats = spacedRepetitionEngine.getReviewStatistics()
        
        currentStreak = 7 // Placeholder - would calculate from user data
        totalFactsLearned = reviewStats.totalFacts
        averageRetention = reviewStats.averageEaseFactor / 2.5 // Normalize to 0-1
        factsADueForReview = reviewStats.dueFacts
    }
    
    private func loadProgressData() async {
        // Generate sample progress data for the last 30 days
        let calendar = Calendar.current
        let endDate = Date()
        let startDate = calendar.date(byAdding: .day, value: -30, to: endDate) ?? endDate
        
        progressData = []
        for i in 0..<30 {
            if let date = calendar.date(byAdding: .day, value: i, to: startDate) {
                progressData.append(ProgressDataPoint(
                    date: date,
                    factsLearned: Int.random(in: 5...15),
                    retention: Double.random(in: 0.7...0.95)
                ))
            }
        }
    }
    
    private func loadSpecialtyStats() async {
        let allFacts = await contentRepository.getAllFacts()
        let specialtyGroups = Dictionary(grouping: allFacts) { $0.specialty }
        
        specialtyStats = specialtyGroups.compactMap { specialty, facts in
            SpecialtyStatistic(
                specialty: specialty,
                factsLearned: Int.random(in: 1...facts.count), // Placeholder
                totalFacts: facts.count
            )
        }.sorted { $0.specialty.rawValue < $1.specialty.rawValue }
    }
    
    private func loadAchievements() {
        achievements = Achievement.defaultAchievements.filter { achievement in
            // Check if achievement is unlocked based on current stats
            switch achievement.type {
            case .streak(let days):
                return currentStreak >= days
            case .factsLearned(let count):
                return totalFactsLearned >= count
            case .retention(let percentage):
                return averageRetention >= percentage
            }
        }
    }
}
