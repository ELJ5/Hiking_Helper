//
//  MessagesListView.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 11/13/25.
//

import Foundation
// Views/Chat/MessagesListView.swift
import SwiftUI

struct MessagesListView: View {
    @ObservedObject var chatManager: ChatManager
    let isLoading: Bool
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                LazyVStack(spacing: 16) {
                    if chatManager.messages.isEmpty {
                        Text("Hello")
                            .padding(.top, 20)
                    }
                    
                    ForEach(chatManager.messages) { message in
                        MessageBubbleView(message: message)
                            .id(message.id)
                    }
                    
                    if isLoading {
                        LoadingIndicator()
                    }
                }
                .padding()
            }
            .onChange(of: chatManager.messages.count) { _, _ in
                if let lastMessage = chatManager.messages.last {
                    withAnimation {
                        proxy.scrollTo(lastMessage.id, anchor: .bottom)
                    }
                }
            }
        }
    }
}

struct LoadingIndicator: View {
    var body: some View {
        HStack {
            ProgressView()
                .scaleEffect(0.8)
            Text("Thinking...")
                .font(.caption)
                .foregroundColor(.secondary)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.leading)
    }
}
