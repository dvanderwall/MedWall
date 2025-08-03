// MARK: - Stats Overview View
// File: MedWall/Features/Home/Views/StatsOverviewView.swift

import SwiftUI

struct StatsOverviewView: View {
    let dailyStreak: Int
    let factsLearned: Int
    let nextReview: Date?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Your Progress")
                .font(.headline)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                StatItemView(
                    title: "Current Streak",
                    value: "\(dailyStreak)",
                    subtitle: "days",
                    icon: "flame",
                    color: .orange
                )
                
                StatItemView(
                    title: "Facts Learned",
                    value: "\(factsLearned)",
                    subtitle: "total",
                    icon: "brain.head.profile",
                    color: .blue
                )
                
                StatItemView(
                    title: "Next Review",
                    value: nextReviewTimeString,
                    subtitle: "upcoming",
                    icon: "clock",
                    color: .green
                )
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var nextReviewTimeString: String {
        guard let nextReview = nextReview else { return "None" }
        
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: nextReview)
    }
}

struct StatItemView: View {
    let title: String
    let value: String
    let subtitle: String
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(color)
            
            Text(value)
                .font(.headline)
                .fontWeight(.bold)
                .foregroundColor(.primary)
            
            VStack(spacing: 2) {
                Text(subtitle)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                Text(title)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
            }
        }
        .padding(.vertical, 8)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}
