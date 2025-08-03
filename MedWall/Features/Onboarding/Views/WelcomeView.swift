// MARK: - Welcome View
// File: MedWall/Features/Onboarding/Views/WelcomeView.swift

import SwiftUI

struct WelcomeView: View {
    var body: some View {
        VStack(spacing: 30) {
            Spacer()
            
            // App Icon/Logo
            Image(systemName: "stethoscope")
                .font(.system(size: 80))
                .foregroundColor(.blue)
            
            VStack(spacing: 16) {
                Text("Welcome to MedWall")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Transform your iPhone wallpaper into a continuous medical education tool")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
                    .padding(.horizontal)
            }
            
            Spacer()
            
            VStack(spacing: 12) {
                FeatureRow(icon: "brain.head.profile", title: "Learn Passively", description: "Medical facts on your wallpaper")
                FeatureRow(icon: "arrow.clockwise", title: "Auto Rotation", description: "New content throughout the day")
                FeatureRow(icon: "chart.line.uptrend.xyaxis", title: "Spaced Repetition", description: "Optimized for retention")
            }
            
            Spacer()
        }
        .padding()
    }
}

struct FeatureRow: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            Image(systemName: icon)
                .font(.title2)
                .foregroundColor(.blue)
                .frame(width: 24)
            
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.headline)
                Text(description)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding(.horizontal)
    }
}
