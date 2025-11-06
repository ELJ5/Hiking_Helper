import SwiftUI

struct HikeRowView: View {
    let hike: Trail
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Image header
                Rectangle()
                    .fill(LinearGradient(
                        colors: [.green.opacity(0.6), .blue.opacity(0.6)],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    ))
                    .frame(height: 150)
                    .overlay {
                        Image(systemName: "mountain.2.fill")
                            .font(.system(size: 50))
                            .foregroundColor(.white.opacity(0.8))
                    }
            
            // Content
            VStack(alignment: .leading, spacing: 8) {
                Text(hike.trailName)
                    .font(.headline)
                
                Text(hike.state)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                HStack(spacing: 16) {
                    
                    Spacer()
                    
                    DifficultyBadge(difficulty: hike.difficultyLevel)
                }
                .font(.caption)
                .foregroundColor(.secondary)
                

            }
            .padding()
        }
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
}

// Helper view for difficulty badge
struct DifficultyBadge: View {
    let difficulty: String
    
    var badgeColor: Color {
        switch difficulty.lowercased() {
        case "easy": return .green
        case "moderate": return .orange
        case "hard", "very hard": return .red
        default: return .gray
        }
    }
    
    var body: some View {
        Text(difficulty)
            .font(.caption)
            .fontWeight(.semibold)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(badgeColor.opacity(0.2))
            .foregroundColor(badgeColor)
            .cornerRadius(6)
    }
}
