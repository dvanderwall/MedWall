// MARK: - Achievement Model
// File: MedWall/Core/Models/Achievement.swift

import Foundation

struct Achievement: Identifiable, Codable {
    let id: UUID
    let title: String
    let description: String
    let icon: String
    let type: AchievementType
    let unlockedDate: Date?
    
    enum AchievementType: Codable {
        case streak(days: Int)
        case factsLearned(count: Int)
        case retention(percentage: Double)
    }
    
    var isUnlocked: Bool {
        unlockedDate != nil
    }
    
    static let defaultAchievements: [Achievement] = [
        Achievement(
            id: UUID(),
            title: "First Steps",
            description: "Learn your first 10 medical facts",
            icon: "star",
            type: .factsLearned(count: 10),
            unlockedDate: nil
        ),
        Achievement(
            id: UUID(),
            title: "Week Warrior",
            description: "Maintain a 7-day learning streak",
            icon: "flame",
            type: .streak(days: 7),
            unlockedDate: nil
        ),
        Achievement(
            id: UUID(),
            title: "Knowledge Master",
            description: "Learn 100 medical facts",
            icon: "brain.head.profile",
            type: .factsLearned(count: 100),
            unlockedDate: nil
        ),
        Achievement(
            id: UUID(),
            title: "Retention Expert",
            description: "Achieve 90% average retention",
            icon: "target",
            type: .retention(percentage: 0.9),
            unlockedDate: nil
        )
    ]
}
