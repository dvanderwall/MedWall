// MARK: - Home View
// File: MedWall/Features/Home/Views/HomeView.swift

import SwiftUI

struct HomeView: View {
    @StateObject private var viewModel = HomeViewModel()
    @State private var showingWallpaperPreview = false
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Current Wallpaper Preview
                    CurrentWallpaperPreview(
                        currentFact: viewModel.currentFact,
                        currentTheme: viewModel.currentTheme
                    )
                    .onTapGesture {
                        showingWallpaperPreview = true
                    }
                    
                    // Quick Actions
                    QuickActionsView(viewModel: viewModel)
                    
                    // Stats Overview
                    StatsOverviewView(
                        dailyStreak: viewModel.userStats.currentStreak,
                        factsLearned: viewModel.userStats.totalFactsLearned,
                        nextReview: viewModel.nextReviewTime
                    )
                    
                    // Recent Facts
                    RecentFactsView(facts: viewModel.recentFacts)
                }
                .padding()
            }
            .navigationTitle("MedWall")
            .refreshable {
                await viewModel.refreshData()
            }
        }
        .sheet(isPresented: $showingWallpaperPreview) {
            WallpaperPreviewView(
                fact: viewModel.currentFact,
                theme: viewModel.currentTheme
            )
        }
        .onAppear {
            Task {
                await viewModel.loadInitialData()
            }
        }
    }
}
