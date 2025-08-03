// MARK: - Missing UI Components
// File: MedWall/Features/Library/Components/CategoryFilterView.swift

import SwiftUI

struct CategoryFilterView: View {
    @Binding var selectedCategory: MedicalFact.Category?
    @Binding var selectedSpecialty: MedicalFact.Specialty?
    @Binding var selectedDifficulty: MedicalFact.Difficulty?
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 12) {
                FilterChip(
                    title: "All Categories",
                    isSelected: selectedCategory == nil
                ) {
                    selectedCategory = nil
                }
                
                ForEach(MedicalFact.Category.allCases, id: \.self) { category in
                    FilterChip(
                        title: category.rawValue,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = selectedCategory == category ? nil : category
                    }
                }
            }
            .padding(.horizontal)
        }
    }
}

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.caption)
                .fontWeight(.medium)
                .padding(.horizontal, 12)
                .padding(.vertical, 6)
                .background(isSelected ? Color.blue : Color(.systemGray5))
                .foregroundColor(isSelected ? .white : .primary)
                .cornerRadius(16)
        }
    }
}

// MARK: - Filter Sheet View
struct FilterSheetView: View {
    @ObservedObject var viewModel: LibraryViewModel
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            Form {
                Section("Category") {
                    Picker("Category", selection: $viewModel.selectedCategory) {
                        Text("All Categories").tag(nil as MedicalFact.Category?)
                        ForEach(MedicalFact.Category.allCases, id: \.self) { category in
                            Text(category.rawValue).tag(category as MedicalFact.Category?)
                        }
                    }
                }
                
                Section("Specialty") {
                    Picker("Specialty", selection: $viewModel.selectedSpecialty) {
                        Text("All Specialties").tag(nil as MedicalFact.Specialty?)
                        ForEach(MedicalFact.Specialty.allCases, id: \.self) { specialty in
                            Text(specialty.rawValue).tag(specialty as MedicalFact.Specialty?)
                        }
                    }
                }
                
                Section("Difficulty") {
                    Picker("Difficulty", selection: $viewModel.selectedDifficulty) {
                        Text("All Levels").tag(nil as MedicalFact.Difficulty?)
                        ForEach(MedicalFact.Difficulty.allCases, id: \.self) { difficulty in
                            Text(difficulty.rawValue).tag(difficulty as MedicalFact.Difficulty?)
                        }
                    }
                }
            }
            .navigationTitle("Filters")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Reset") {
                        viewModel.selectedCategory = nil
                        viewModel.selectedSpecialty = nil
                        viewModel.selectedDifficulty = nil
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

// MARK: - Fact Detail View
struct FactDetailView: View {
    let fact: MedicalFact
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(alignment: .leading, spacing: 20) {
                    // Fact Content
                    VStack(alignment: .leading, spacing: 12) {
                        Text("Medical Fact")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        Text(fact.content)
                            .font(.body)
                            .lineSpacing(4)
                    }
                    
                    // Meta Information
                    VStack(alignment: .leading, spacing: 16) {
                        DetailRow(title: "Specialty", value: fact.specialty.rawValue)
                        DetailRow(title: "Category", value: fact.category.rawValue)
                        DetailRow(title: "Difficulty", value: fact.difficulty.rawValue)
                        DetailRow(title: "Source", value: fact.source)
                        
                        if !fact.tags.isEmpty {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Tags")
                                    .font(.subheadline)
                                    .fontWeight(.medium)
                                
                                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80))], spacing: 8) {
                                    ForEach(fact.tags, id: \.self) { tag in
                                        Text(tag)
                                            .font(.caption)
                                            .padding(.horizontal, 8)
                                            .padding(.vertical, 4)
                                            .background(Color.blue.opacity(0.1))
                                            .cornerRadius(8)
                                    }
                                }
                            }
                        }
                    }
                    
                    Spacer()
                }
                .padding()
            }
            .navigationTitle("Fact Details")
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
}

struct DetailRow: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(title)
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(.secondary)
            
            Text(value)
                .font(.body)
        }
    }
}

// MARK: - Onboarding Views
struct SpecialtySelectionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 16) {
                Text("Choose Your Specialties")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Select the medical specialties you're most interested in learning about")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            
            ScrollView {
                LazyVGrid(columns: [GridItem(.adaptive(minimum: 150))], spacing: 16) {
                    ForEach(MedicalFact.Specialty.allCases, id: \.self) { specialty in
                        SpecialtyCard(
                            specialty: specialty,
                            isSelected: viewModel.selectedSpecialties.contains(specialty)
                        ) {
                            if viewModel.selectedSpecialties.contains(specialty) {
                                viewModel.selectedSpecialties.remove(specialty)
                            } else {
                                viewModel.selectedSpecialties.insert(specialty)
                            }
                        }
                    }
                }
                .padding()
            }
            
            Button(action: viewModel.nextStep) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.selectedSpecialties.isEmpty ? Color.gray : Color.blue)
                    .cornerRadius(12)
            }
            .disabled(viewModel.selectedSpecialties.isEmpty)
            .padding(.horizontal)
        }
        .padding()
    }
}

struct SpecialtyCard: View {
    let specialty: MedicalFact.Specialty
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            VStack(spacing: 8) {
                Image(systemName: "stethoscope")
                    .font(.title)
                    .foregroundColor(isSelected ? .white : .blue)
                
                Text(specialty.rawValue)
                    .font(.caption)
                    .fontWeight(.medium)
                    .multilineTextAlignment(.center)
                    .foregroundColor(isSelected ? .white : .primary)
            }
            .frame(height: 100)
            .frame(maxWidth: .infinity)
            .background(isSelected ? Color.blue : Color(.systemGray6))
            .cornerRadius(12)
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(Color.blue, lineWidth: isSelected ? 2 : 0)
            )
        }
    }
}

struct DifficultySelectionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 16) {
                Text("Select Difficulty Level")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Choose your current level of medical knowledge")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 16) {
                ForEach(MedicalFact.Difficulty.allCases, id: \.self) { difficulty in
                    DifficultyCard(
                        difficulty: difficulty,
                        isSelected: viewModel.selectedDifficulty == difficulty
                    ) {
                        viewModel.selectedDifficulty = difficulty
                    }
                }
            }
            .padding()
            
            Button(action: viewModel.nextStep) {
                Text("Continue")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct DifficultyCard: View {
    let difficulty: MedicalFact.Difficulty
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text(difficulty.rawValue)
                        .font(.headline)
                        .fontWeight(.semibold)
                        .foregroundColor(isSelected ? .white : .primary)
                    
                    Text(difficultyDescription)
                        .font(.body)
                        .foregroundColor(isSelected ? .white.opacity(0.8) : .secondary)
                }
                
                Spacer()
                
                if isSelected {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundColor(.white)
                        .font(.title2)
                }
            }
            .padding()
            .background(isSelected ? Color.blue : Color(.systemGray6))
            .cornerRadius(12)
        }
    }
    
    private var difficultyDescription: String {
        switch difficulty {
        case .medicalStudent:
            return "Basic medical concepts and fundamentals"
        case .resident:
            return "Clinical knowledge and board review content"
        case .attending:
            return "Advanced topics and specialized knowledge"
        }
    }
}

struct ShortcutsSetupView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 16) {
                Text("iOS Shortcuts Setup")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Set up automated wallpaper rotation using iOS Shortcuts")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            
            VStack(spacing: 20) {
                SetupStepView(
                    number: 1,
                    title: "Open Shortcuts App",
                    description: "Launch the iOS Shortcuts app on your device"
                )
                
                SetupStepView(
                    number: 2,
                    title: "Create Automation",
                    description: "Tap '+' and create a new Personal Automation"
                )
                
                SetupStepView(
                    number: 3,
                    title: "Set Trigger",
                    description: "Choose 'Time of Day' and set your preferred intervals"
                )
                
                SetupStepView(
                    number: 4,
                    title: "Add MedWall Action",
                    description: "Search for 'MedWall' and add the wallpaper generation action"
                )
            }
            
            Button(action: viewModel.nextStep) {
                Text("I'll Set This Up Later")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.blue)
                    .cornerRadius(12)
            }
            .padding(.horizontal)
        }
        .padding()
    }
}

struct SetupStepView: View {
    let number: Int
    let title: String
    let description: String
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                Circle()
                    .fill(Color.blue)
                    .frame(width: 30, height: 30)
                
                Text("\(number)")
                    .font(.headline)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.headline)
                    .fontWeight(.semibold)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
    }
}

struct FirstWallpaperView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    let appConfiguration: AppConfiguration
    @State private var isGenerating = false
    @State private var generatedFact: MedicalFact?
    @State private var isCompleting = false
    
    var body: some View {
        VStack(spacing: 30) {
            VStack(spacing: 16) {
                Text("You're All Set!")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                
                Text("Let's generate your first medical wallpaper")
                    .font(.body)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            
            // Preview of first wallpaper
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(LinearGradient(colors: [.blue, .purple], startPoint: .topLeading, endPoint: .bottomTrailing))
                    .frame(height: 300)
                
                VStack {
                    Spacer()
                    
                    if let fact = generatedFact {
                        VStack(spacing: 8) {
                            Text(fact.content)
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                            
                            HStack {
                                Text(fact.specialty.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Spacer()
                                
                                Text(fact.difficulty.rawValue)
                                    .font(.caption)
                                    .foregroundColor(.white.opacity(0.8))
                            }
                            .padding(.horizontal)
                        }
                    } else {
                        if isGenerating {
                            VStack(spacing: 12) {
                                ProgressView()
                                    .scaleEffect(1.2)
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                                
                                Text("Generating your first medical fact...")
                                    .font(.body)
                                    .foregroundColor(.white)
                            }
                        } else {
                            Text("Tap below to generate your first medical wallpaper")
                                .font(.body)
                                .fontWeight(.medium)
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                                .padding(.horizontal)
                        }
                    }
                    
                    Spacer()
                }
            }
            .padding()
            
            Button(action: handleButtonPress) {
                HStack {
                    if isGenerating || isCompleting {
                        ProgressView()
                            .scaleEffect(0.8)
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                    }
                    
                    Text(buttonText)
                        .font(.headline)
                }
                .foregroundColor(.white)
                .frame(maxWidth: .infinity)
                .padding()
                .background(Color.blue)
                .cornerRadius(12)
            }
            .disabled(isGenerating || isCompleting)
            .padding(.horizontal)
        }
        .padding()
    }
    
    private var buttonText: String {
        if isCompleting {
            return "Completing Setup..."
        } else if generatedFact == nil {
            return "Generate First Wallpaper"
        } else {
            return "Complete Setup"
        }
    }
    
    private func handleButtonPress() {
        if generatedFact != nil {
            // Complete onboarding
            completeOnboarding()
        } else {
            // Generate wallpaper
            generateFirstWallpaper()
        }
    }
    
    private func generateFirstWallpaper() {
        isGenerating = true
        
        Task {
            await loadSampleFact()
            
            await MainActor.run {
                isGenerating = false
            }
        }
    }
    
    private func completeOnboarding() {
        Logger.shared.log("FirstWallpaperView: Starting onboarding completion")
        isCompleting = true
        
        // Save preferences
        viewModel.saveUserPreferencesPublic()
        
        // Update app configuration directly (we're already on MainActor)
        Logger.shared.log("FirstWallpaperView: Updating app configuration")
        appConfiguration.completeOnboarding()
        
        // Update view model
        viewModel.isCompleted = true
        
        isCompleting = false
        
        Logger.shared.log("FirstWallpaperView: Onboarding completion finished")
    }
    
    private func loadSampleFact() async {
        // Create a sample medical fact for the preview
        let sampleFact = MedicalFact(
            content: "The most common cause of sudden cardiac death in young athletes is hypertrophic cardiomyopathy.",
            category: .clinical,
            specialty: .cardiology,
            difficulty: viewModel.selectedDifficulty,
            source: "Harrison's Principles of Internal Medicine",
            tags: ["cardiology", "sudden death", "athletes"]
        )
        
        // Simulate network delay
        try? await Task.sleep(nanoseconds: 1_500_000_000) // 1.5 seconds
        
        await MainActor.run {
            generatedFact = sampleFact
        }
    }
}

// MARK: - Additional Settings Views (placeholders from previous implementation)
// ... rest of the views remain the same ...
