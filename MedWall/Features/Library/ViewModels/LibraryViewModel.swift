// MARK: - Library ViewModel
// File: MedWall/Features/Library/ViewModels/LibraryViewModel.swift

import SwiftUI
import Combine

@MainActor
class LibraryViewModel: ObservableObject {
    @Published var allFacts: [MedicalFact] = []
    @Published var filteredFacts: [MedicalFact] = []
    @Published var favoriteFacts: [MedicalFact] = []
    @Published var selectedFact: MedicalFact?
    
    @Published var selectedCategory: MedicalFact.Category?
    @Published var selectedSpecialty: MedicalFact.Specialty?
    @Published var selectedDifficulty: MedicalFact.Difficulty?
    
    @Published var isLoading = false
    @Published var searchResults: [MedicalFact] = []
    
    private let contentRepository = ContentRepository.shared
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupFilterSubscriptions()
    }
    
    func loadFacts() async {
        isLoading = true
        allFacts = await contentRepository.getAllFacts()
        applyFilters()
        isLoading = false
    }
    
    func refreshFacts() async {
        await contentRepository.loadInitialFacts()
        await loadFacts()
    }
    
    func searchFacts(query: String) async {
        if query.isEmpty {
            searchResults = []
            applyFilters()
        } else {
            searchResults = await contentRepository.searchFacts(query: query)
            filteredFacts = searchResults
        }
    }
    
    func toggleFavorite(_ fact: MedicalFact) {
        // Implementation for favorites
        if favoriteFacts.contains(where: { $0.id == fact.id }) {
            favoriteFacts.removeAll { $0.id == fact.id }
        } else {
            favoriteFacts.append(fact)
        }
        saveFavorites()
    }
    
    private func setupFilterSubscriptions() {
        Publishers.CombineLatest3($selectedCategory, $selectedSpecialty, $selectedDifficulty)
            .debounce(for: .milliseconds(300), scheduler: RunLoop.main)
            .sink { [weak self] _, _, _ in
                self?.applyFilters()
            }
            .store(in: &cancellables)
    }
    
    private func applyFilters() {
        var filtered = searchResults.isEmpty ? allFacts : searchResults
        
        if let category = selectedCategory {
            filtered = filtered.filter { $0.category == category }
        }
        
        if let specialty = selectedSpecialty {
            filtered = filtered.filter { $0.specialty == specialty }
        }
        
        if let difficulty = selectedDifficulty {
            filtered = filtered.filter { $0.difficulty == difficulty }
        }
        
        filteredFacts = filtered
    }
    
    private func saveFavorites() {
        // Save to UserDefaults or Core Data
        let favoriteIds = favoriteFacts.map { $0.id.uuidString }
        UserDefaults.standard.set(favoriteIds, forKey: "FavoriteFacts")
    }
}
