// MARK: - Quick Actions View
// File: MedWall/Features/Home/Views/QuickActionsView.swift

import SwiftUI

struct QuickActionsView: View {
    @ObservedObject var viewModel: HomeViewModel
    @State private var isGenerating = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Quick Actions")
                .font(.headline)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: [
                GridItem(.flexible()),
                GridItem(.flexible())
            ], spacing: 12) {
                ActionButton(
                    title: "New Wallpaper",
                    icon: "arrow.clockwise",
                    color: .blue,
                    isLoading: isGenerating
                ) {
                    await generateNewWallpaper()
                }
                
                ActionButton(
                    title: "Random Fact",
                    icon: "dice",
                    color: .green
                ) {
                    await getRandomFact()
                }
                
                ActionButton(
                    title: "Review Facts",
                    icon: "brain.head.profile",
                    color: .orange
                ) {
                    // Navigate to review session
                }
                
                ActionButton(
                    title: "Settings",
                    icon: "gear",
                    color: .gray
                ) {
                    // Navigate to settings
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private func generateNewWallpaper() async {
        isGenerating = true
        await viewModel.generateNewWallpaper()
        isGenerating = false
    }
    
    private func getRandomFact() async {
        // Implementation for random fact
    }
}

struct ActionButton: View {
    let title: String
    let icon: String
    let color: Color
    var isLoading: Bool = false
    let action: () async -> Void
    
    var body: some View {
        Button {
            Task {
                await action()
            }
        } label: {
            VStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .scaleEffect(0.8)
                } else {
                    Image(systemName: icon)
                        .font(.title2)
                }
                
                Text(title)
                    .font(.caption)
                    .fontWeight(.medium)
            }
            .foregroundColor(color)
            .frame(maxWidth: .infinity)
            .frame(height: 60)
            .background(color.opacity(0.1))
            .cornerRadius(8)
        }
        .disabled(isLoading)
    }
}
