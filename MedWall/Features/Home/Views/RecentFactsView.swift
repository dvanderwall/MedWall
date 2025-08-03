// MARK: - Recent Facts View
// File: MedWall/Features/Home/Views/RecentFactsView.swift

import SwiftUI

struct RecentFactsView: View {
    let facts: [MedicalFact]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recently Viewed")
                    .font(.headline)
                    .foregroundColor(.primary)
                
                Spacer()
                
                Button("View All") {
                    // TODO: Navigate to library
                }
                .font(.caption)
                .foregroundColor(.blue)
            }
            
            if facts.isEmpty {
                EmptyRecentFactsView()
            } else {
                LazyVStack(spacing: 8) {
                    ForEach(facts.prefix(3)) { fact in
                        RecentFactItemView(fact: fact)
                    }
                }
            }
        }
        .padding()
        .background(Color(.systemGray6))
        .cornerRadius(12)
    }
}

struct RecentFactItemView: View {
    let fact: MedicalFact
    
    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            Text(fact.content)
                .font(.body)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
            
            HStack {
                Label(fact.specialty.rawValue, systemImage: "stethoscope")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                if let lastShown = fact.lastShown {
                    Text(timeAgoString(from: lastShown))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.vertical, 8)
        .padding(.horizontal, 12)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
    
    private func timeAgoString(from date: Date) -> String {
        let formatter = RelativeDateTimeFormatter()
        formatter.unitsStyle = .abbreviated
        return formatter.localizedString(for: date, relativeTo: Date())
    }
}

struct EmptyRecentFactsView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "clock.arrow.circlepath")
                .font(.system(size: 40))
                .foregroundColor(.secondary)
            
            Text("No recent facts")
                .font(.body)
                .foregroundColor(.secondary)
            
            Text("Generate your first wallpaper to get started!")
                .font(.caption)
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
        }
        .padding(.vertical, 20)
        .frame(maxWidth: .infinity)
        .background(Color(.systemBackground))
        .cornerRadius(8)
    }
}
