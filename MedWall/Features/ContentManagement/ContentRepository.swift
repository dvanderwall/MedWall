// MARK: - Content Repository
// File: MedWall/Features/ContentManagement/ContentRepository.swift

import Foundation
import CoreData

class ContentRepository: ObservableObject {
    static let shared = ContentRepository()
    
    private let coreDataStack = CoreDataStack.shared
    private let firebaseManager = FirebaseManager.shared
    
    @Published var allFacts: [MedicalFact] = []
    @Published var isLoading = false
    
    private init() {
        loadFactsFromLocalStorage()
    }
    
    func getAllFacts() async -> [MedicalFact] {
        if allFacts.isEmpty {
            await loadInitialFacts()
        }
        return allFacts
    }
    
    func loadInitialFacts() async {
        isLoading = true
        defer { isLoading = false }
        
        // First try to load from local storage
        loadFactsFromLocalStorage()
        
        // If no local facts, load from bundle
        if allFacts.isEmpty {
            loadFactsFromBundle()
        }
        
        // Sync with Firebase in background
        Task {
            await syncWithFirebase()
        }
    }
    
    func getFactsByCategory(_ category: MedicalFact.Category) async -> [MedicalFact] {
        let facts = await getAllFacts()
        return facts.filter { $0.category == category }
    }
    
    func getFactsBySpecialty(_ specialty: MedicalFact.Specialty) async -> [MedicalFact] {
        let facts = await getAllFacts()
        return facts.filter { $0.specialty == specialty }
    }
    
    func getFactsByDifficulty(_ difficulty: MedicalFact.Difficulty) async -> [MedicalFact] {
        let facts = await getAllFacts()
        return facts.filter { $0.difficulty == difficulty }
    }
    
    func searchFacts(query: String) async -> [MedicalFact] {
        let facts = await getAllFacts()
        let lowercaseQuery = query.lowercased()
        
        return facts.filter { fact in
            fact.content.lowercased().contains(lowercaseQuery) ||
            fact.tags.contains { $0.lowercased().contains(lowercaseQuery) } ||
            fact.specialty.rawValue.lowercased().contains(lowercaseQuery) ||
            fact.category.rawValue.lowercased().contains(lowercaseQuery)
        }
    }
    
    func getRecentlyViewedFacts(limit: Int) async -> [MedicalFact] {
        let facts = await getAllFacts()
        return Array(facts
            .filter { $0.lastShown != nil }
            .sorted { $0.lastShown! > $1.lastShown! }
            .prefix(limit))
    }
    
    func getFavorites() async -> [MedicalFact] {
        // Implementation would check user favorites
        return []
    }
    
    private func loadFactsFromLocalStorage() {
        // Load from Core Data
        let request: NSFetchRequest<MedicalFactEntity> = MedicalFactEntity.fetchRequest()
        
        do {
            let entities = try coreDataStack.context.fetch(request)
            allFacts = entities.compactMap { convertEntityToModel($0) }
        } catch {
            Logger.shared.log("Failed to load facts from Core Data: \(error)", level: .error)
        }
    }
    
    private func loadFactsFromBundle() {
        // Load initial facts from JSON file in bundle
        guard let url = Bundle.main.url(forResource: "InitialFacts", withExtension: "json"),
              let data = try? Data(contentsOf: url) else {
            Logger.shared.log("Failed to load InitialFacts.json", level: .error)
            createSampleFacts()
            return
        }
        
        do {
            allFacts = try JSONDecoder().decode([MedicalFact].self, from: data)
            saveFactsToLocalStorage(allFacts)
            Logger.shared.log("Loaded \(allFacts.count) facts from bundle")
        } catch {
            Logger.shared.log("Failed to decode facts from bundle: \(error)", level: .error)
            createSampleFacts()
        }
    }
    
    private func createSampleFacts() {
        // Create sample facts for development
        allFacts = [
            MedicalFact(
                content: "The most common cause of sudden cardiac death in young athletes is hypertrophic cardiomyopathy.",
                category: .clinical,
                specialty: .cardiology,
                difficulty: .resident,
                source: "Harrison's Principles of Internal Medicine",
                tags: ["cardiology", "sudden death", "athletes", "hypertrophic cardiomyopathy"]
            ),
            MedicalFact(
                content: "Beck's triad consists of elevated JVP, muffled heart sounds, and hypotension - classic signs of cardiac tamponade.",
                category: .clinical,
                specialty: .emergency,
                difficulty: .medicalStudent,
                source: "Emergency Medicine Secrets",
                tags: ["emergency", "cardiac tamponade", "Beck's triad"]
            ),
            MedicalFact(
                content: "Virchow's triad for thrombosis: endothelial injury, hypercoagulability, and venous stasis.",
                category: .pathology,
                specialty: .internal,
                difficulty: .medicalStudent,
                source: "Robbins Pathologic Basis of Disease",
                tags: ["pathology", "thrombosis", "Virchow's triad"]
            )
        ]
        
        saveFactsToLocalStorage(allFacts)
    }
    
    private func saveFactsToLocalStorage(_ facts: [MedicalFact]) {
        for fact in facts {
            saveFactToLocalStorage(fact)
        }
        coreDataStack.save()
    }
    
    private func saveFactToLocalStorage(_ fact: MedicalFact) {
        let entity = MedicalFactEntity(context: coreDataStack.context)
        entity.id = fact.id
        entity.content = fact.content
        entity.category = fact.category.rawValue
        entity.specialty = fact.specialty.rawValue
        entity.difficulty = fact.difficulty.rawValue
        entity.source = fact.source
        entity.tags = fact.tags.joined(separator: ",")
        entity.dateAdded = fact.dateAdded
        entity.lastShown = fact.lastShown
        entity.timesShown = Int32(fact.timesShown)
        entity.userRating = Int16(fact.userRating ?? 0)
    }
    
    private func convertEntityToModel(_ entity: MedicalFactEntity) -> MedicalFact? {
        guard let id = entity.id,
              let content = entity.content,
              let categoryString = entity.category,
              let category = MedicalFact.Category(rawValue: categoryString),
              let specialtyString = entity.specialty,
              let specialty = MedicalFact.Specialty(rawValue: specialtyString),
              let difficultyString = entity.difficulty,
              let difficulty = MedicalFact.Difficulty(rawValue: difficultyString),
              let source = entity.source,
              let dateAdded = entity.dateAdded else {
            return nil
        }
        
        let tags = entity.tags?.components(separatedBy: ",") ?? []
        
        var fact = MedicalFact(
            id: id,
            content: content,
            category: category,
            specialty: specialty,
            difficulty: difficulty,
            source: source,
            tags: tags
        )
        
        // Update with stored values
        fact.lastShown = entity.lastShown
        fact.timesShown = Int(entity.timesShown)
        fact.userRating = entity.userRating > 0 ? Int(entity.userRating) : nil
        
        return fact
    }
    
    private func syncWithFirebase() async {
        do {
            let remoteFacts = try await firebaseManager.fetchMedicalFacts()
            
            // Merge with local facts (simple implementation)
            let newFacts = remoteFacts.filter { remoteFact in
                !allFacts.contains { $0.id == remoteFact.id }
            }
            
            if !newFacts.isEmpty {
                await MainActor.run {
                    allFacts.append(contentsOf: newFacts)
                }
                saveFactsToLocalStorage(newFacts)
                Logger.shared.log("Synced \(newFacts.count) new facts from Firebase")
            }
        } catch {
            Logger.shared.log("Firebase sync failed: \(error)", level: .error)
        }
    }
}
