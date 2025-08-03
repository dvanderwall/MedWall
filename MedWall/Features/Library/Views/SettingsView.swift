// MARK: - Settings View
// File: MedWall/Features/Settings/Views/SettingsView.swift

import SwiftUI

struct SettingsView: View {
    @StateObject private var viewModel = SettingsViewModel()
    
    var body: some View {
        NavigationView {
            Form {
                // Content Preferences Section
                Section("Content Preferences") {
                    NavigationLink("Specialties & Difficulty") {
                        ContentPreferencesView(viewModel: viewModel)
                    }
                    
                    NavigationLink("Learning Goals") {
                        LearningGoalsView(viewModel: viewModel)
                    }
                }
                
                // Wallpaper Settings Section
                Section("Wallpaper Settings") {
                    NavigationLink("Rotation Schedule") {
                        RotationSettingsView(viewModel: viewModel)
                    }
                    
                    NavigationLink("Visual Themes") {
                        VisualThemesView(viewModel: viewModel)
                    }
                    
                    NavigationLink("Layout Options") {
                        LayoutOptionsView(viewModel: viewModel)
                    }
                }
                
                // iOS Integration Section
                Section("iOS Integration") {
                    HStack {
                        Text("Shortcuts Setup")
                        Spacer()
                        Button("Configure") {
                            viewModel.setupShortcuts()
                        }
                        .foregroundColor(.blue)
                    }
                    
                    Toggle("Background Updates", isOn: $viewModel.backgroundUpdatesEnabled)
                    Toggle("Notifications", isOn: $viewModel.notificationsEnabled)
                }
                
                // Data & Privacy Section
                Section("Data & Privacy") {
                    NavigationLink("Account") {
                        AccountView(viewModel: viewModel)
                    }
                    
                    NavigationLink("Data Management") {
                        DataManagementView(viewModel: viewModel)
                    }
                    
                    NavigationLink("Privacy Policy") {
                        WebView(url: URL(string: "https://medwall.app/privacy")!)
                    }
                }
                
                // Support Section
                Section("Support") {
                    HStack {
                        Text("Rate MedWall")
                        Spacer()
                        Button("Rate") {
                            viewModel.requestAppStoreReview()
                        }
                        .foregroundColor(.blue)
                    }
                    
                    HStack {
                        Text("Send Feedback")
                        Spacer()
                        Button("Email") {
                            viewModel.sendFeedback()
                        }
                        .foregroundColor(.blue)
                    }
                    
                    HStack {
                        Text("Version")
                        Spacer()
                        Text(viewModel.appVersion)
                            .foregroundColor(.secondary)
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .onAppear {
            viewModel.loadSettings()
        }
    }
}
