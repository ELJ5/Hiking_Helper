//
//  UserPreferences.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 11/5/25.
//

import Foundation

class UserPreferences: ObservableObject {
    @Published var trailPreferences: TrailPreferences {
        didSet {
            save()  // Auto-save whenever preferences change
        }
    }
    
    private let preferencesKey = "userTrailPreferences"
    
    init() {
        // Load saved preferences on init
        self.trailPreferences = UserPreferences.load()
    }
    
    // Load preferences from UserDefaults
    static func load() -> TrailPreferences {
        guard let data = UserDefaults.standard.data(forKey: "userTrailPreferences"),
              let preferences = try? JSONDecoder().decode(TrailPreferences.self, from: data) else {
            return TrailPreferences.default
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
        trailPreferences = TrailPreferences.default
    }
    
    // Check if onboarding is complete
    var needsOnboarding: Bool {
        !trailPreferences.hasCompletedOnboarding
    }
}

// MARK: - Trail Preferences Model
struct TrailPreferences: Codable {
    var helper: Bool
    var hikingFrequency: String
    var desiredDistance: String
    var currentCapability: String
    var difficulty: String
    var elevation: String
    var location: String?
    var travelRadius: String
    var hasCompletedOnboarding: Bool
    var minDistance: Double
    var maxDistance: Double
    
    // NEW: Track completed trails by their IDs
    var completedTrails: [Int]
    
    // Default values
    static var `default`: TrailPreferences {
        TrailPreferences(
            helper: false,
            hikingFrequency: "",
            desiredDistance: "",
            currentCapability: "",
            difficulty: "Easy",
            elevation: "Low",
            location: nil,
            travelRadius: "",
            hasCompletedOnboarding: false,
            minDistance: 0.0,
            maxDistance: 10.0,
            completedTrails: []  // Empty array by default
        )
    }
}

// MARK: - Convenience Extensions
extension TrailPreferences {
    // Check if user is a beginner
    var isBeginner: Bool {
        return hikingFrequency == "Never have" ||
               hikingFrequency == "Once a year" ||
               currentCapability == "0-2 miles"
    }
    
    // Check if user wants to progress
    var wantsToProgress: Bool {
        return helper && currentCapability != desiredDistance
    }
    
    // Get distance as a range for display
    var distanceRangeText: String {
        return String(format: "%.1f - %.1f miles", minDistance, maxDistance)
    }
    
    // Check if all required fields are filled
    var isComplete: Bool {
        return !hikingFrequency.isEmpty &&
               !desiredDistance.isEmpty &&
               !currentCapability.isEmpty &&
               !difficulty.isEmpty &&
               !elevation.isEmpty &&
               hasCompletedOnboarding
    }
    
    // Check if a trail is completed
    func isTrailCompleted(_ trailId: Int) -> Bool {
        return completedTrails.contains(trailId)
    }
    
    // Number of completed trails
    var completedTrailCount: Int {
        return completedTrails.count
    }
}

// MARK: - Completed Trail Management
extension UserPreferences {
    // Mark a trail as completed
    func markTrailCompleted(_ trailId: Int) {
        if !trailPreferences.completedTrails.contains(trailId) {
            trailPreferences.completedTrails.append(trailId)
        }
    }
    
    // Unmark a trail as completed
    func unmarkTrailCompleted(_ trailId: Int) {
        trailPreferences.completedTrails.removeAll { $0 == trailId }
    }
    
    // Toggle trail completion
    func toggleTrailCompletion(_ trailId: Int) {
        if trailPreferences.completedTrails.contains(trailId) {
            unmarkTrailCompleted(trailId)
        } else {
            markTrailCompleted(trailId)
        }
    }
    
    // Clear all completed trails
    func clearCompletedTrails() {
        trailPreferences.completedTrails = []
    }
}
