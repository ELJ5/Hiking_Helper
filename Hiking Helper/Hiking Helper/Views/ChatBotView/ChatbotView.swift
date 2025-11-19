//
//  ChatbotView.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 11/13/25.
//

import Foundation
import SwiftUI

struct ChatbotView: View {
    @EnvironmentObject var userPreferences: UserPreferences
    @StateObject private var chatManager = ChatManager()
    @State private var messageText = ""
    @State private var isLoading = false
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            ChatHeaderView()
            
            // Messages List
            MessagesListView(
                chatManager: chatManager,
                isLoading: isLoading
            )
            
            // Input Bar
            ChatInputBar(
                messageText: $messageText,
                isTextFieldFocused: $isTextFieldFocused,
                isLoading: isLoading,
                onSend: sendMessage
            )
        }
        .onAppear {
            if chatManager.messages.isEmpty {
                chatManager.loadWelcomeMessage(userPreferences: userPreferences)
            }
        }
    }
    
    private func sendMessage() {
        let trimmedMessage = messageText.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmedMessage.isEmpty else { return }
        
        chatManager.addMessage(content: trimmedMessage, role: .user)
        messageText = ""
        isTextFieldFocused = false
        isLoading = true
        
        Task {
            await chatManager.sendMessage(userPreferences: userPreferences)
            isLoading = false
        }
    }
}

#Preview{
    ChatbotView()
}
