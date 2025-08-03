// MARK: - Current Wallpaper Preview Component
// File: MedWall/Features/Home/Views/CurrentWallpaperPreview.swift

import SwiftUI

struct CurrentWallpaperPreview: View {
    let currentFact: MedicalFact?
    let currentTheme: WallpaperTheme
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Current Wallpaper")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("Preview") {
                    // Action handled by parent
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            // Miniature wallpaper preview
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(
                        LinearGradient(
                            colors: themeGradientColors,
                            startPoint: .topLeading,
                            endPoint: .bottomTrailing
                        )
                    )
                    .aspectRatio(9/19.5, contentMode: .fit) // iPhone aspect ratio
                
                VStack {
                    Spacer()
                    
                    if let fact = currentFact {
                        Text(fact.content)
                            .font(.system(size: 8, weight: .medium))
                            .foregroundColor(.white)
                            .multilineTextAlignment(.center)
                            .padding(.horizontal, 8)
                            .shadow(radius: 1)
                    } else {
                        Text("No fact selected")
                            .font(.system(size: 8))
                            .foregroundColor(.white.opacity(0.7))
                    }
                    
                    Spacer()
                }
                .padding(8)
            }
            .frame(height: 200)
            
            if let fact = currentFact {
                HStack {
                    Label(fact.specialty.rawValue, systemImage: "stethoscope")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Label(fact.difficulty.rawValue, systemImage: "graduationcap")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
    
    private var themeGradientColors: [Color] {
        switch currentTheme.backgroundType {
        case .gradient(let colors):
            return colors.compactMap { Color(hex: $0) }
        case .solid(let color):
            return [Color(hex: color), Color(hex: color)].compactMap { $0 }
        default:
            return [.blue, .purple]
        }
    }
}
