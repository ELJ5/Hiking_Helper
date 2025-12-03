////
////  ChatManager.swift
////  Hiking Helper
////
////  Created by Eliana Johnson on 11/13/25.
////
//
//import Foundation
//// ViewModels/ChatManager.swift
//import Foundation
//
//@MainActor
//class ChatManager: ObservableObject {
//    @Published var messages: [ChatMessage] = []
//    private let apiService = OpenAIService()
//    
//    func loadWelcomeMessage(userPreferences: UserPreferences) {
//        let prefs = userPreferences.trailPreferences
//        var welcomeText = "Hi! I'm your hiking assistant. "
//        
//        if prefs.helper {
//            welcomeText += "I see you're interested in building your hiking skills. "
//        }
//        
//        if let location = prefs.location {
//            welcomeText += "I can help you find great trails near \(location). "
//        }
//        
//        welcomeText += "What would you like to know?"
//        
//        messages.append(ChatMessage(content: welcomeText, role: .assistant))
//    }
//    
//    func addMessage(content: String, role: MessageRole) {
//        messages.append(ChatMessage(content: content, role: role))
//    }
//    
//    func sendMessage(userPreferences: UserPreferences) async {
//        do {
//            let response = try await apiService.sendChatMessage(
//                messages: messages,
//                userPreferences: userPreferences
//            )
//            addMessage(content: response, role: .assistant)
//        } catch {
//            addMessage(content: "Sorry, I encountered an error. Please try again.", role: .assistant)
//            print("Error: \(error.localizedDescription)")
//        }
//    }
//}
