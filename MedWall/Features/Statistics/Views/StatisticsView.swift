// MARK: - Statistics View
// File: MedWall/Features/Statistics/Views/StatisticsView.swift

import SwiftUI

struct StatisticsView: View {
    @StateObject private var viewModel = StatisticsViewModel()
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Overview Cards
                    LazyVGrid(columns: [
                        GridItem(.flexible()),
                        GridItem(.flexible())
                    ], spacing: 16) {
                        StatCardView(
                            title: "Current Streak",
                            value: "\(viewModel.currentStreak)",
                            subtitle: "days",
                            icon: "flame",
                            color: .orange
                        )
                        
                        StatCardView(
                            title: "Facts Learned",
                            value: "\(viewModel.totalFactsLearned)",
                            subtitle: "total",
                            icon: "brain.head.profile",
                            color: .blue
                        )
                        
                        StatCardView(
                            title: "Avg. Retention",
                            value: "\(Int(viewModel.averageRetention * 100))%",
                            subtitle: "accuracy",
                            icon: "chart.line.uptrend.xyaxis",
                            color: .green
                        )
                        
                        StatCardView(
                            title: "Due for Review",
                            value: "\(viewModel.factsADueForReview)",
                            subtitle: "facts",
                            icon: "clock",
                            color: .purple
                        )
                    }
                    
                    // Learning Progress Chart
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Learning Progress")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ProgressChartView(data: viewModel.progressData)
                            .frame(height: 200)
                            .padding()
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                    
                    // Specialty Breakdown
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Knowledge by Specialty")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        ForEach(viewModel.specialtyStats, id: \.specialty) { stat in
                            SpecialtyProgressRow(
                                specialty: stat.specialty,
                                factsLearned: stat.factsLearned,
                                totalFacts: stat.totalFacts
                            )
                        }
                        .padding(.horizontal)
                    }
                    
                    // Achievements
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Achievements")
                            .font(.headline)
                            .padding(.horizontal)
                        
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 12) {
                            ForEach(viewModel.achievements, id: \.id) { achievement in
                                AchievementBadgeView(achievement: achievement)
                            }
                        }
                        .padding(.horizontal)
                    }
                }
                .padding(.vertical)
            }
            .navigationTitle("Statistics")
            .refreshable {
                await viewModel.refreshData()
            }
        }
        .onAppear {
            Task {
                await viewModel.loadData()
            }
        }
    }
}
