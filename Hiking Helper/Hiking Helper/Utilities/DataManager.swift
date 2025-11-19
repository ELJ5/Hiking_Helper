//
//  DataManager.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 11/5/25.
//

import Foundation
import Combine

class DataManager: ObservableObject {
    
    @Published var allTrails: [Trail] = []
    @Published var isLoading: Bool = false
    @Published var lastLoadedDate: Date?
    
    private var hasLoadedData = false  // Prevents multiple loads
    
    // Reference to user preferences
    var userPreferences: UserPreferences
    
    // ✅ CHANGED: Removed default parameter to ensure userPreferences is always passed
    init(userPreferences: UserPreferences) {
        self.userPreferences = userPreferences
    }
    
    // COMPUTED property - filters cached data without reloading
    var filteredTrails: [Trail] {
        let prefs = userPreferences.trailPreferences
        
        return allTrails.filter { trail in
            // Distance filter
            guard trail.distanceMiles >= prefs.minDistance && trail.distanceMiles <= prefs.maxDistance else {
                return false
            }
            
            // Difficulty filter (if you want to add this)
            if !prefs.difficulty.isEmpty {
                // Uncomment and adjust based on your Trail model's difficulty property
                // guard trail.difficulty == prefs.difficulty else {
                //     return false
                // }
            }
            
            // Elevation filter (if you want to add this)
            if !prefs.elevation.isEmpty {
                // Uncomment and adjust based on your Trail model's elevation property
                // guard trail.elevationCategory == prefs.elevation else {
                //     return false
                // }
            }
            
            // Location filter
            if let location = prefs.location, !location.isEmpty {
                // You can add location-based filtering here if your Trail model has location data
                // guard trail.location.contains(location) else { return false }
            }
            
            return true
        }
    }
    
    // Load data ONCE - only when needed
    func loadTrailsIfNeeded() {
        guard !hasLoadedData else {
            print("✅ Data already loaded from cache")
            return
        }
        
        loadTrails()
    }
    
    // Force reload (for pull-to-refresh)
    func loadTrails() {
        isLoading = true
        
        // Simulate loading large file
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            if let loadedTrails = JSONLoader.load("testTrails", as: [Trail].self) {
                DispatchQueue.main.async {
                    self?.allTrails = loadedTrails
                    self?.hasLoadedData = true
                    self?.lastLoadedDate = Date()
                    self?.isLoading = false
                    print("✅ Loaded \(loadedTrails.count) trails into cache")
                }
            } else {
                DispatchQueue.main.async {
                    self?.isLoading = false
                    print("❌ Failed to load trails")
                }
            }
        }
    }
    
    // Refresh data (e.g., pull-to-refresh)
    func refresh() {
        hasLoadedData = false
        loadTrails()
    }
    
    // Clear cache (for memory management)
    func clearCache() {
        allTrails = []
        hasLoadedData = false
        lastLoadedDate = nil
    }
}

// MARK: - Additional Filtering Methods
extension DataManager {
    
    // Get trails filtered by specific difficulty
    func trails(withDifficulty difficulty: String) -> [Trail] {
        return filteredTrails.filter { trail in
            // Adjust based on your Trail model's difficulty property
            // trail.difficulty == difficulty
            true // placeholder
        }
    }
    
    // Get trails within a specific distance range
    func trails(minDistance: Double, maxDistance: Double) -> [Trail] {
        return allTrails.filter { trail in
            trail.distanceMiles >= minDistance && trail.distanceMiles <= maxDistance
        }
    }
    
    // Get beginner-friendly trails
    var beginnerTrails: [Trail] {
        return filteredTrails.filter { trail in
            trail.distanceMiles <= 3.0
            // && trail.difficulty == "Easy"  // Add when you have difficulty property
        }
    }
    
    // Get trails matching user's goal
    var progressionTrails: [Trail] {
        let prefs = userPreferences.trailPreferences
        
        // If user wants to progress, show slightly challenging trails
        if prefs.wantsToProgress {
            let targetDistance = prefs.maxDistance * 1.2  // 20% increase
            return allTrails.filter { trail in
                trail.distanceMiles > prefs.maxDistance &&
                trail.distanceMiles <= targetDistance
            }
        }
        
        return filteredTrails
    }
}
