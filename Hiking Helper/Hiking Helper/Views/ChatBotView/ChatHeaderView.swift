//
//  ChatHeaderView.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 11/13/25.
//

import Foundation
// Views/Chat/ChatHeaderView.swift
import SwiftUI

struct ChatHeaderView: View {
    var body: some View {
        HStack {
            Image(systemName: "figure.hiking")
                .font(.title2)
                .foregroundColor(.green)
            
            VStack(alignment: .leading, spacing: 2) {
                Text("Hiking Assistant")
                    .font(.headline)
                Text("Your personal trail guide")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
        }
        .padding()
        .background(Color(.systemBackground))
        .shadow(color: .black.opacity(0.1), radius: 2, y: 2)
    }
}
