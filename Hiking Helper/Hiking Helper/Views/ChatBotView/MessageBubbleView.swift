//
//  MessageBubbleView.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 11/13/25.
//

import Foundation
import SwiftUI

struct MessageBubbleView: View {
    let message: ChatMessage
    
    var body: some View {
        HStack {
            if message.role == .user {
                Spacer(minLength: 60)
            }
            
            VStack(alignment: message.role == .user ? .trailing : .leading, spacing: 4) {
                Text(message.content)
                    .padding(12)
                    .background(message.role == .user ? Color.green : Color(.systemGray5))
                    .foregroundColor(message.role == .user ? .white : .primary)
                    .cornerRadius(16)
                
                Text(message.timestamp, style: .time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
            
            if message.role == .assistant {
                Spacer(minLength: 60)
            }
        }
    }
}

// Preview
#Preview {
    VStack(spacing: 16) {
        MessageBubbleView(message: ChatMessage(
            content: "Hi! I'm your hiking assistant. What would you like to know?",
            role: .assistant
        ))
        
        MessageBubbleView(message: ChatMessage(
            content: "Can you suggest some easy trails near me?",
            role: .user
        ))
        
        MessageBubbleView(message: ChatMessage(
            content: "Sure! Based on your location, I'd recommend:\n\n• Eagle Creek Trail - 2.5 miles, easy\n• Waterfall Loop - 1.8 miles, flat terrain\n• Forest Ridge Path - 3.2 miles, moderate",
            role: .assistant
        ))
    }
    .padding()
}
