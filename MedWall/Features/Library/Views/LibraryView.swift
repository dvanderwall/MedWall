// MARK: - Library View
// File: MedWall/Features/Library/Views/LibraryView.swift

import SwiftUI

struct LibraryView: View {
    @StateObject private var viewModel = LibraryViewModel()
    @State private var searchText = ""
    @State private var showingFilters = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Search Bar
                SearchBar(text: $searchText, onSearchButtonClicked: {
                    Task {
                        await viewModel.searchFacts(query: searchText)
                    }
                })
                .padding(.horizontal)
                
                // Filter Bar
                CategoryFilterView(
                    selectedCategory: $viewModel.selectedCategory,
                    selectedSpecialty: $viewModel.selectedSpecialty,
                    selectedDifficulty: $viewModel.selectedDifficulty
                )
                
                // Facts List
                if viewModel.isLoading {
                    LoadingView()
                } else if viewModel.filteredFacts.isEmpty {
                    EmptyStateView(
                        title: "No Facts Found",
                        message: "Try adjusting your filters or search terms",
                        systemImage: "books.vertical"
                    )
                } else {
                    List {
                        ForEach(viewModel.filteredFacts) { fact in
                            FactListItemView(fact: fact) {
                                viewModel.toggleFavorite(fact)
                            }
                            .onTapGesture {
                                viewModel.selectedFact = fact
                            }
                        }
                    }
                    .refreshable {
                        await viewModel.refreshFacts()
                    }
                }
            }
            .navigationTitle("Medical Library")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Filters") {
                        showingFilters = true
                    }
                }
            }
            .sheet(isPresented: $showingFilters) {
                FilterSheetView(viewModel: viewModel)
            }
            .sheet(item: $viewModel.selectedFact) { fact in
                FactDetailView(fact: fact)
            }
        }
        .onAppear {
            Task {
                await viewModel.loadFacts()
            }
        }
    }
}
