// MARK: - Core Data Models
// File: MedWall/Core/Models/MedicalFact.swift

import Foundation
import CoreData

struct MedicalFact: Identifiable, Codable {
    let id: UUID
    let content: String
    let category: Category
    let specialty: Specialty
    let difficulty: Difficulty
    let source: String
    let tags: [String]
    let dateAdded: Date
    var lastShown: Date?
    var timesShown: Int
    var userRating: Int?
    var spacedRepetitionData: SpacedRepetitionInfo
    
    enum Category: String, CaseIterable, Codable {
        case basicScience = "Basic Science"
        case clinical = "Clinical"
        case pharmacology = "Pharmacology"
        case anatomy = "Anatomy"
        case pathology = "Pathology"
        case procedures = "Procedures"
        case differential = "Differential Diagnosis"
    }
    
    enum Specialty: String, CaseIterable, Codable {
        case cardiology = "Cardiology"
        case neurology = "Neurology"
        case emergency = "Emergency Medicine"
        case surgery = "Surgery"
        case internalMedicine = "Internal Medicine"
        case pediatrics = "Pediatrics"
        case psychiatry = "Psychiatry"
        case radiology = "Radiology"
        case dermatology = "Dermatology"
        case orthopedics = "Orthopedics"
        case obgyn = "OB/GYN"
        case anesthesiology = "Anesthesiology"
        case pathologySpecialty = "Pathology"
        case familyMedicine = "Family Medicine"
        case infectious = "Infectious Disease"
        case endocrinology = "Endocrinology"
        case rheumatology = "Rheumatology"
        case gastroenterology = "Gastroenterology"
        case pulmonology = "Pulmonology"
        case hematology = "Hematology/Oncology"
    }
    
    enum Difficulty: String, CaseIterable, Codable {
        case medicalStudent = "Medical Student"
        case resident = "Resident"
        case attending = "Attending"
        
        var level: Int {
            switch self {
            case .medicalStudent: return 1
            case .resident: return 2
            case .attending: return 3
            }
        }
    }
    
    init(id: UUID = UUID(), content: String, category: Category, specialty: Specialty,
         difficulty: Difficulty, source: String, tags: [String] = []) {
        self.id = id
        self.content = content
        self.category = category
        self.specialty = specialty
        self.difficulty = difficulty
        self.source = source
        self.tags = tags
        self.dateAdded = Date()
        self.lastShown = nil
        self.timesShown = 0
        self.userRating = nil
        self.spacedRepetitionData = SpacedRepetitionInfo()
    }
}
