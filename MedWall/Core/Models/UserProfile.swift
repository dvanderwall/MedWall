// MARK: - User Profile Model
// File: MedWall/Core/Models/UserProfile.swift

import Foundation

struct UserProfile: Codable {
    let id: UUID
    var email: String?
    var name: String?
    var selectedSpecialties: Set<MedicalFact.Specialty>
    var preferredDifficulty: MedicalFact.Difficulty
    var rotationSettings: RotationSettings
    var learningGoals: LearningGoals
    var createdDate: Date
    var lastActiveDate: Date
    
    struct RotationSettings: Codable {
        var isEnabled: Bool
        var frequency: Frequency // How often to rotate wallpaper
        var quietHours: QuietHours // Time range when no rotations occur
        var backgroundUpdateEnabled: Bool
        
        enum Frequency: String, CaseIterable, Codable {
            case fifteenMinutes = "15 minutes"
            case thirtyMinutes = "30 minutes"
            case oneHour = "1 hour"
            case twoHours = "2 hours"
            case fourHours = "4 hours"
            case sixHours = "6 hours"
            case twelveHours = "12 hours"
            case daily = "Daily"
            
            var timeInterval: TimeInterval {
                switch self {
                case .fifteenMinutes: return 15 * 60
                case .thirtyMinutes: return 30 * 60
                case .oneHour: return 60 * 60
                case .twoHours: return 2 * 60 * 60
                case .fourHours: return 4 * 60 * 60
                case .sixHours: return 6 * 60 * 60
                case .twelveHours: return 12 * 60 * 60
                case .daily: return 24 * 60 * 60
                }
            }
        }
        
        struct QuietHours: Codable {
            var isEnabled: Bool
            var startTime: Date // Time of day
            var endTime: Date // Time of day
        }
        
        init() {
            self.isEnabled = true
            self.frequency = .twoHours
            self.quietHours = QuietHours(isEnabled: true,
                                       startTime: Calendar.current.date(from: DateComponents(hour: 22)) ?? Date(),
                                       endTime: Calendar.current.date(from: DateComponents(hour: 7)) ?? Date())
            self.backgroundUpdateEnabled = true
        }
    }
    
    struct LearningGoals: Codable {
        var dailyFactsTarget: Int
        var weeklyStudyStreak: Int
        var currentStreak: Int
        var longestStreak: Int
        var totalFactsLearned: Int
        var averageRetention: Double
        
        init() {
            self.dailyFactsTarget = 10
            self.weeklyStudyStreak = 0
            self.currentStreak = 0
            self.longestStreak = 0
            self.totalFactsLearned = 0
            self.averageRetention = 0.0
        }
    }
    
    init(email: String? = nil, name: String? = nil) {
        self.id = UUID()
        self.email = email
        self.name = name
        self.selectedSpecialties = [.internal, .emergency]
        self.preferredDifficulty = .resident
        self.rotationSettings = RotationSettings()
        self.learningGoals = LearningGoals()
        self.createdDate = Date()
        self.lastActiveDate = Date()
    }
}
