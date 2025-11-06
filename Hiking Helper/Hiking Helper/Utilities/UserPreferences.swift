//
//  UserPreferences.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 11/5/25.
//

import Foundation

class UserPreferences: ObservableObject {
    @Published var trailPreferences: FilterPreferences {
        didSet {
            save()  // Auto-save whenever preferences change
        }
    }
    
    private let preferencesKey = "userFilterPreferences"
    
    init() {
        // Load saved preferences on init
        self.trailPreferences = UserPreferences.load()
    }
    
    // Load preferences from UserDefaults
    static func load() -> FilterPreferences {
        guard let data = UserDefaults.standard.data(forKey: "userFilterPreferences"),
              let preferences = try? JSONDecoder().decode(FilterPreferences.self, from: data) else {
            return FilterPreferences.default
        }
        return preferences
    }
    
    // Save preferences to UserDefaults
    private func save() {
        guard let data = try? JSONEncoder().encode(trailPreferences) else { return }
        UserDefaults.standard.set(data, forKey: preferencesKey)
    }
    
    // Reset to defaults
    func reset() {
        trailPreferences = FilterPreferences.default
    }
    
    // Check if onboarding is complete
    var needsOnboarding: Bool {
        !trailPreferences.hasCompletedOnboarding
    }
}
