// MARK: - Wallpaper Preview View
// File: MedWall/Features/WallpaperEngine/Views/WallpaperPreviewView.swift

import SwiftUI

struct WallpaperPreviewView: View {
    let fact: MedicalFact?
    let theme: WallpaperTheme
    @Environment(\.dismiss) private var dismiss
    @State private var isGenerating = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 20) {
                // Phone Frame Preview
                VStack {
                    Text("Wallpaper Preview")
                        .font(.headline)
                        .padding(.bottom)
                    
                    ZStack {
                        // Phone frame
                        RoundedRectangle(cornerRadius: 25)
                            .fill(Color.black)
                            .frame(width: 250, height: 540)
                        
                        // Screen content
                        RoundedRectangle(cornerRadius: 20)
                            .fill(backgroundGradient)
                            .frame(width: 240, height: 520)
                            .overlay(
                                WallpaperContentView(fact: fact, theme: theme)
                            )
                            .clipShape(RoundedRectangle(cornerRadius: 20))
                    }
                }
                
                // Action Buttons
                VStack(spacing: 12) {
                    Button(action: generateNewWallpaper) {
                        HStack {
                            if isGenerating {
                                ProgressView()
                                    .scaleEffect(0.8)
                                    .foregroundColor(.white)
                            } else {
                                Image(systemName: "arrow.clockwise")
                            }
                            Text("Generate New")
                        }
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                    .disabled(isGenerating)
                    
                    Button("Save to Photos") {
                        saveWallpaperToPhotos()
                    }
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color(.systemGray5))
                    .foregroundColor(.primary)
                    .cornerRadius(10)
                }
                .padding(.horizontal)
                
                Spacer()
            }
            .padding()
            .navigationTitle("Wallpaper")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
    
    private var backgroundGradient: LinearGradient {
        switch theme.backgroundType {
        case .gradient(let colors):
            let swiftUIColors = colors.compactMap { Color(hex: $0) }
            return LinearGradient(
                colors: swiftUIColors.isEmpty ? [.blue, .purple] : swiftUIColors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        case .solid(let color):
            let solidColor = Color(hex: color) ?? .blue
            return LinearGradient(colors: [solidColor], startPoint: .top, endPoint: .bottom)
        default:
            return LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
    
    private func generateNewWallpaper() {
        isGenerating = true
        
        // Simulate wallpaper generation
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            isGenerating = false
            // TODO: Implement actual wallpaper generation
        }
    }
    
    private func saveWallpaperToPhotos() {
        // TODO: Implement save to photos
        print("Saving wallpaper to Photos...")
    }
}

struct WallpaperContentView: View {
    let fact: MedicalFact?
    let theme: WallpaperTheme
    
    var body: some View {
        VStack {
            Spacer()
            
            if let fact = fact {
                VStack(spacing: 8) {
                    Text(fact.content)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white)
                        .multilineTextAlignment(.center)
                        .padding(.horizontal, 16)
                        .shadow(radius: 2)
                    
                    HStack {
                        Text(fact.specialty.rawValue)
                            .font(.system(size: 8))
                            .foregroundColor(.white.opacity(0.8))
                        
                        Spacer()
                        
                        Text(fact.difficulty.rawValue)
                            .font(.system(size: 8))
                            .foregroundColor(.white.opacity(0.8))
                    }
                    .padding(.horizontal, 20)
                }
            } else {
                Text("No medical fact selected")
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.7))
                    .multilineTextAlignment(.center)
            }
            
            Spacer()
            
            // MedWall branding
            HStack {
                Spacer()
                Text("MedWall")
                    .font(.system(size: 8, weight: .light))
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.trailing, 8)
                    .padding(.bottom, 8)
            }
        }
    }
}
