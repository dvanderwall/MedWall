// MARK: - Fact List Item Component
// File: MedWall/Features/Library/Components/FactListItemView.swift

import SwiftUI

struct FactListItemView: View {
    let fact: MedicalFact
    let onFavoriteToggle: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Content
            Text(fact.content)
                .font(.body)
                .lineLimit(3)
                .fixedSize(horizontal: false, vertical: true)
            
            // Meta information
            HStack {
                Label(fact.specialty.rawValue, systemImage: "stethoscope")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Spacer()
                
                Label(fact.difficulty.rawValue, systemImage: "graduationcap")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Button(action: onFavoriteToggle) {
                    Image(systemName: "heart")
                        .foregroundColor(.red)
                }
            }
            
            // Tags
            if !fact.tags.isEmpty {
                HStack {
                    ForEach(Array(fact.tags.prefix(3)), id: \.self) { tag in
                        Text(tag)
                            .font(.caption2)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(4)
                    }
                    
                    if fact.tags.count > 3 {
                        Text("+\(fact.tags.count - 3)")
                            .font(.caption2)
                            .foregroundColor(.secondary)
                    }
                    
                    Spacer()
                }
            }
        }
        .padding(.vertical, 4)
    }
}
