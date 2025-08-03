// MARK: - Charts Integration Fix
// File: MedWall/Features/Statistics/Components/ProgressChartView.swift

import SwiftUI

// Temporary placeholder for Charts until proper integration
struct ProgressChartView: View {
    let data: [StatisticsViewModel.ProgressDataPoint]
    
    var body: some View {
        VStack {
            Text("Progress Chart")
                .font(.headline)
                .padding()
            
            Text("Chart implementation coming soon")
                .font(.caption)
                .foregroundColor(.secondary)
            
            // Placeholder chart representation
            GeometryReader { geometry in
                Path { path in
                    guard !data.isEmpty else { return }
                    
                    let width = geometry.size.width
                    let height = geometry.size.height
                    let stepWidth = width / CGFloat(data.count - 1)
                    
                    for (index, point) in data.enumerated() {
                        let x = CGFloat(index) * stepWidth
                        let y = height - (height * CGFloat(point.retention))
                        
                        if index == 0 {
                            path.move(to: CGPoint(x: x, y: y))
                        } else {
                            path.addLine(to: CGPoint(x: x, y: y))
                        }
                    }
                }
                .stroke(Color.blue, lineWidth: 2)
            }
            .frame(height: 120)
            .padding()
        }
    }
}

// MARK: - Specialty Progress Row
struct SpecialtyProgressRow: View {
    let specialty: MedicalFact.Specialty
    let factsLearned: Int
    let totalFacts: Int
    
    var progress: Double {
        guard totalFacts > 0 else { return 0 }
        return Double(factsLearned) / Double(totalFacts)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(specialty.rawValue)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Spacer()
                
                Text("\(factsLearned)/\(totalFacts)")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            ProgressView(value: progress)
                .progressViewStyle(LinearProgressViewStyle(tint: .blue))
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Achievement Badge View
struct AchievementBadgeView: View {
    let achievement: Achievement
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                Circle()
                    .fill(achievement.isUnlocked ? Color.yellow : Color.gray.opacity(0.3))
                    .frame(width: 50, height: 50)
                
                Image(systemName: achievement.icon)
                    .font(.title2)
                    .foregroundColor(achievement.isUnlocked ? .black : .gray)
            }
            
            VStack(spacing: 2) {
                Text(achievement.title)
                    .font(.caption)
                    .fontWeight(.semibold)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                
                Text(achievement.description)
                    .font(.caption2)
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
            }
        }
        .opacity(achievement.isUnlocked ? 1.0 : 0.6)
    }
}

// MARK: - Web View for Privacy Policy
struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> some UIView {
        // For now, just return a placeholder view
        let label = UILabel()
        label.text = "Privacy Policy\n\nOpen in Safari: \(url.absoluteString)"
        label.textAlignment = .center
        label.numberOfLines = 0
        return label
    }
    
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // No updates needed
    }
}

// MARK: - Settings Detail Views Placeholders
struct ContentPreferencesView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Form {
            Section("Medical Specialties") {
                Text("Specialty selection interface")
                    .foregroundColor(.secondary)
            }
            
            Section("Difficulty Level") {
                Picker("Difficulty", selection: $viewModel.userProfile.preferredDifficulty) {
                    ForEach(MedicalFact.Difficulty.allCases, id: \.self) { difficulty in
                        Text(difficulty.rawValue).tag(difficulty)
                    }
                }
            }
        }
        .navigationTitle("Content Preferences")
    }
}

struct LearningGoalsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Form {
            Section("Daily Goals") {
                Stepper("Daily Facts: \(viewModel.userProfile.learningGoals.dailyFactsTarget)",
                       value: $viewModel.userProfile.learningGoals.dailyFactsTarget,
                       in: 1...50)
            }
            
            Section("Current Progress") {
                HStack {
                    Text("Current Streak")
                    Spacer()
                    Text("\(viewModel.userProfile.learningGoals.currentStreak) days")
                        .foregroundColor(.secondary)
                }
                
                HStack {
                    Text("Longest Streak")
                    Spacer()
                    Text("\(viewModel.userProfile.learningGoals.longestStreak) days")
                        .foregroundColor(.secondary)
                }
            }
        }
        .navigationTitle("Learning Goals")
    }
}

struct RotationSettingsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Form {
            Section("Rotation") {
                Toggle("Auto Rotation", isOn: $viewModel.userProfile.rotationSettings.isEnabled)
                
                if viewModel.userProfile.rotationSettings.isEnabled {
                    Picker("Frequency", selection: $viewModel.userProfile.rotationSettings.frequency) {
                        ForEach(UserProfile.RotationSettings.Frequency.allCases, id: \.self) { frequency in
                            Text(frequency.rawValue).tag(frequency)
                        }
                    }
                }
            }
            
            Section("Quiet Hours") {
                Toggle("Enable Quiet Hours", isOn: $viewModel.userProfile.rotationSettings.quietHours.isEnabled)
                
                if viewModel.userProfile.rotationSettings.quietHours.isEnabled {
                    DatePicker("Start Time",
                             selection: $viewModel.userProfile.rotationSettings.quietHours.startTime,
                             displayedComponents: .hourAndMinute)
                    
                    DatePicker("End Time",
                             selection: $viewModel.userProfile.rotationSettings.quietHours.endTime,
                             displayedComponents: .hourAndMinute)
                }
            }
        }
        .navigationTitle("Rotation Settings")
    }
}

struct VisualThemesView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        List {
            ForEach(WallpaperTheme.defaultThemes) { theme in
                ThemeRowView(
                    theme: theme,
                    isSelected: viewModel.selectedTheme.id == theme.id
                ) {
                    viewModel.selectedTheme = theme
                }
            }
        }
        .navigationTitle("Visual Themes")
    }
}

struct ThemeRowView: View {
    let theme: WallpaperTheme
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                // Theme preview
                RoundedRectangle(cornerRadius: 8)
                    .fill(themeGradient)
                    .frame(width: 50, height: 30)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(theme.name)
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Text(theme.description)
                        .font(.caption)
                        .foregroundColor(.secondary)
                        .lineLimit(2)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.blue)
                }
            }
            .padding(.vertical, 4)
        }
    }
    
    private var themeGradient: LinearGradient {
        switch theme.backgroundType {
        case .gradient(let colors):
            let swiftUIColors = colors.compactMap { Color(hex: $0) }
            return LinearGradient(
                colors: swiftUIColors.isEmpty ? [.blue] : swiftUIColors,
                startPoint: .leading,
                endPoint: .trailing
            )
        case .solid(let color):
            let solidColor = Color(hex: color) ?? .blue
            return LinearGradient(colors: [solidColor], startPoint: .leading, endPoint: .trailing)
        default:
            return LinearGradient(colors: [.blue], startPoint: .leading, endPoint: .trailing)
        }
    }
}

struct LayoutOptionsView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Form {
            Section("Text Layout") {
                Text("Layout options coming soon")
                    .foregroundColor(.secondary)
            }
        }
        .navigationTitle("Layout Options")
    }
}

struct AccountView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Form {
            Section("Account Information") {
                if let email = viewModel.userProfile.email {
                    HStack {
                        Text("Email")
                        Spacer()
                        Text(email)
                            .foregroundColor(.secondary)
                    }
                } else {
                    Text("Not signed in")
                        .foregroundColor(.secondary)
                }
            }
            
            Section("Actions") {
                Button("Sign Out") {
                    // Implement sign out
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Account")
    }
}

struct DataManagementView: View {
    @ObservedObject var viewModel: SettingsViewModel
    
    var body: some View {
        Form {
            Section("Data") {
                Button("Export Data") {
                    // Implement data export
                }
                
                Button("Clear Cache") {
                    // Implement cache clearing
                }
            }
            
            Section("Reset") {
                Button("Reset All Settings") {
                    // Implement settings reset
                }
                .foregroundColor(.red)
            }
        }
        .navigationTitle("Data Management")
    }
}
