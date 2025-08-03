// MARK: - Spaced Repetition Engine
// File: MedWall/Features/SpacedRepetition/SpacedRepetitionEngine.swift

import Foundation

class SpacedRepetitionEngine: ObservableObject {
    static let shared = SpacedRepetitionEngine()
    
    private let contentRepository = ContentRepository.shared
    private var factSchedule: [UUID: SpacedRepetitionInfo] = [:]
    
    private init() {
        loadScheduleFromStorage()
    }
    
    func getNextFactForReview() async -> MedicalFact? {
        let now = Date()
        let availableFacts = await contentRepository.getAllFacts()
        
        // Filter facts that are due for review
        let dueFacts = availableFacts.filter { fact in
            guard let schedule = factSchedule[fact.id] else {
                // New fact - add to schedule
                factSchedule[fact.id] = SpacedRepetitionInfo()
                return true
            }
            return schedule.nextReviewDate <= now
        }
        
        // Sort by priority (overdue facts first, then by ease factor)
        let sortedFacts = dueFacts.sorted { fact1, fact2 in
            guard let schedule1 = factSchedule[fact1.id],
                  let schedule2 = factSchedule[fact2.id] else {
                return false
            }
            
            // Prioritize overdue facts
            let overdue1 = schedule1.nextReviewDate < now
            let overdue2 = schedule2.nextReviewDate < now
            
            if overdue1 != overdue2 {
                return overdue1
            }
            
            // Then by ease factor (harder facts first)
            return schedule1.easeFactor < schedule2.easeFactor
        }
        
        return sortedFacts.first
    }
    
    func getCurrentFact() async -> MedicalFact? {
        // Return the most recently shown fact or get next for review
        return await getNextFactForReview()
    }
    
    func markFactAsShown(_ fact: MedicalFact) {
        guard var schedule = factSchedule[fact.id] else {
            factSchedule[fact.id] = SpacedRepetitionInfo()
            return
        }
        
        // Update the schedule to reflect that the fact was shown
        // This is passive viewing, not active recall, so we use a neutral quality
        schedule.updateAfterReview(quality: .hesitant, responseTime: 0)
        factSchedule[fact.id] = schedule
        
        saveScheduleToStorage()
    }
    
    func recordUserFeedback(for fact: MedicalFact, quality: SpacedRepetitionInfo.ReviewSession.Quality, responseTime: TimeInterval) {
        guard var schedule = factSchedule[fact.id] else {
            var newSchedule = SpacedRepetitionInfo()
            newSchedule.updateAfterReview(quality: quality, responseTime: responseTime)
            factSchedule[fact.id] = newSchedule
            return
        }
        
        schedule.updateAfterReview(quality: quality, responseTime: responseTime)
        factSchedule[fact.id] = schedule
        
        saveScheduleToStorage()
        Logger.shared.log("Updated spaced repetition for fact: \(fact.id)")
    }
    
    func getNextReviewTime() -> Date? {
        let upcomingReviews = factSchedule.values
            .map { $0.nextReviewDate }
            .filter { $0 > Date() }
            .sorted()
        
        return upcomingReviews.first
    }
    
    func getReviewStatistics() -> ReviewStatistics {
        let now = Date()
        let schedules = Array(factSchedule.values)
        
        let totalFacts = schedules.count
        let dueFacts = schedules.filter { $0.nextReviewDate <= now }.count
        let averageEaseFactor = schedules.isEmpty ? 0 : schedules.map { $0.easeFactor }.reduce(0, +) / Double(schedules.count)
        let averageInterval = schedules.isEmpty ? 0 : schedules.map { $0.interval }.reduce(0, +) / schedules.count
        
        return ReviewStatistics(
            totalFacts: totalFacts,
            dueFacts: dueFacts,
            averageEaseFactor: averageEaseFactor,
            averageInterval: averageInterval
        )
    }
    
    private func loadScheduleFromStorage() {
        // Load from UserDefaults or Core Data
        if let data = UserDefaults.standard.data(forKey: "SpacedRepetitionSchedule"),
           let schedule = try? JSONDecoder().decode([String: SpacedRepetitionInfo].self, from: data) {
            factSchedule = Dictionary(uniqueKeysWithValues: schedule.compactMap { key, value in
                guard let uuid = UUID(uuidString: key) else { return nil }
                return (uuid, value)
            })
        }
    }
    
    private func saveScheduleToStorage() {
        let stringKeySchedule = Dictionary(uniqueKeysWithValues: factSchedule.map { key, value in
            (key.uuidString, value)
        })
        
        if let data = try? JSONEncoder().encode(stringKeySchedule) {
            UserDefaults.standard.set(data, forKey: "SpacedRepetitionSchedule")
        }
    }
    
    struct ReviewStatistics {
        let totalFacts: Int
        let dueFacts: Int
        let averageEaseFactor: Double
        let averageInterval: Int
    }
}
