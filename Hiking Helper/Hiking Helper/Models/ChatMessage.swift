//
//  ChatMessage.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 11/13/25.
//

import Foundation
// Models/ChatMessage.swift
import Foundation

struct ChatMessage: Identifiable, Codable {
    let id: UUID
    let content: String
    let role: MessageRole
    let timestamp: Date
    
    init(id: UUID = UUID(), content: String, role: MessageRole, timestamp: Date = Date()) {
        self.id = id
        self.content = content
        self.role = role
        self.timestamp = timestamp
    }
}

enum MessageRole: String, Codable {
    case user
    case assistant
    case system
}
