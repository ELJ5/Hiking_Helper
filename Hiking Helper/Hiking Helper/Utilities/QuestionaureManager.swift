//
//  QuestionaureManager.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 10/18/25.
//

import Foundation

class QuestionnaireManager {
    private static let questionsKey = "savedQuestions"
    
    static func save(_ questions: [Question]) {
        guard let data = try? JSONEncoder().encode(questions) else { return }
        UserDefaults.standard.set(data, forKey: questionsKey)
    }
    
    static func load() -> [Question]? {
        guard let data = UserDefaults.standard.data(forKey: questionsKey),
              let questions = try? JSONDecoder().decode([Question].self, from: data) else {
            return nil
        }
        return questions
    }
    
    static func clear() {
        UserDefaults.standard.removeObject(forKey: questionsKey)
    }
}
