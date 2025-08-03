// MARK: - SpacedRepetitionInfo (needed for MedicalFact)
// File: MedWall/Core/Models/SpacedRepetitionInfo.swift

import Foundation

struct SpacedRepetitionInfo: Codable {
    var interval: Int // Days until next review
    var repetition: Int // Number of times reviewed
    var easeFactor: Double // SM-2 ease factor (min: 1.3)
    var nextReviewDate: Date
    var lastReviewDate: Date?
    var reviewHistory: [ReviewSession]
    
    init() {
        self.interval = 1
        self.repetition = 0
        self.easeFactor = 2.5
        self.nextReviewDate = Date()
        self.lastReviewDate = nil
        self.reviewHistory = []
    }
    
    struct ReviewSession: Codable {
        let date: Date
        let quality: Quality // User's response quality (0-5)
        let responseTime: TimeInterval // Time taken to respond
        
        enum Quality: Int, CaseIterable, Codable {
            case blackout = 0 // Complete blackout
            case incorrect = 1 // Incorrect response
            case difficult = 2 // Correct with serious difficulty
            case hesitant = 3 // Correct with hesitation
            case easy = 4 // Correct with ease
            case perfect = 5 // Perfect response
            
            var description: String {
                switch self {
                case .blackout: return "Didn't remember"
                case .incorrect: return "Incorrect"
                case .difficult: return "Hard"
                case .hesitant: return "Good"
                case .easy: return "Easy"
                case .perfect: return "Perfect"
                }
            }
        }
    }
    
    mutating func updateAfterReview(quality: ReviewSession.Quality, responseTime: TimeInterval) {
        let session = ReviewSession(date: Date(), quality: quality, responseTime: responseTime)
        reviewHistory.append(session)
        lastReviewDate = Date()
        repetition += 1
        
        // SM-2 Algorithm implementation
        if quality.rawValue >= 3 {
            if repetition == 1 {
                interval = 1
            } else if repetition == 2 {
                interval = 6
            } else {
                interval = Int(Double(interval) * easeFactor)
            }
        } else {
            repetition = 0
            interval = 1
        }
        
        // Update ease factor
        easeFactor = easeFactor + (0.1 - (5 - Double(quality.rawValue)) * (0.08 + (5 - Double(quality.rawValue)) * 0.02))
        easeFactor = max(1.3, easeFactor)
        
        // Set next review date
        nextReviewDate = Calendar.current.date(byAdding: .day, value: interval, to: Date()) ?? Date()
    }
}
