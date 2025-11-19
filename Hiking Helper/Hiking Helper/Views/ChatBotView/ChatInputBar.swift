//
//  ChatInputBar.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 11/13/25.
//

import Foundation
// Views/Chat/ChatInputBar.swift
import SwiftUI

struct ChatInputBar: View {
    @Binding var messageText: String
    var isTextFieldFocused: FocusState<Bool>.Binding
    let isLoading: Bool
    let onSend: () -> Void
    
    var body: some View {
        VStack(spacing: 0) {
            Divider()
            
            HStack(spacing: 12) {
                TextField("Ask about trails, training, gear...", text: $messageText, axis: .vertical)
                    .textFieldStyle(.plain)
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(20)
                    .focused(isTextFieldFocused)
                    .lineLimit(1...4)
                
                Button(action: onSend) {
                    Image(systemName: "arrow.up.circle.fill")
                        .font(.system(size: 32))
                        .foregroundColor(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ? .gray : .green)
                }
                .disabled(messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || isLoading)
            }
            .padding(.horizontal)
            .padding(.vertical, 8)
        }
        .background(Color(.systemBackground))
    }
}
