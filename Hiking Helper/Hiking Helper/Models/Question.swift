//
//  Question.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 11/5/25.
//

import Foundation

struct Question: Identifiable, Codable {
    let id: UUID
    let text: String
    let options: [String]
    var selectedOption: String?
    let preferenceKey: String  // Maps to FilterPreferences property
    
    init(id: UUID = UUID(), text: String, options: [String], preferenceKey: String, selectedOption: String? = nil) {
        self.id = id
        self.text = text
        self.options = options
        self.preferenceKey = preferenceKey
        self.selectedOption = selectedOption
    }
}
