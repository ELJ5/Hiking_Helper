//
//  DataManager.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 11/5/25.
//

import Foundation
import Combine

class DataManager: ObservableObject {
    // CACHED data - loaded once and kept in memory
    @Published var allTrails: [Trail] = []
    @Published var isLoading: Bool = false
    @Published var lastLoadedDate: Date?
    
    private var hasLoadedData = false  // Prevents multiple loads
    
    // Reference to user preferences
    var userPreferences: UserPreferences
    
    init(userPreferences: UserPreferences) {
        self.userPreferences = userPreferences
    }
    
    // COMPUTED property - filters cached data without reloading
    var filteredTrails: [Trail] {
        let prefs = userPreferences.trailPreferences
        
        return allTrails.filter { trail in
            //distance
            guard trail.distanceMiles >= prefs.minDistance && trail.distanceMiles <= prefs.maxDistance else {
                return false
            }
            
            // difficulty filter
            //if !prefs.interests.isEmpty {
                // Assuming User model has interests property
                // let userInterests = Set(user.interests ?? [])
                // let preferredInterests = Set(prefs.interests)
                // guard !userInterests.isDisjoint(with: preferredInterests) else {
                //     return false
                // }
            //}
            
            // elevation filter
            if let location = prefs.location, !location.isEmpty {
                // guard user.location == location else { return false }
            }
            
            //helper filter or activator
            
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
            if let loadedTrails = JSONLoader.load("trails", as: [Trail].self) {
                DispatchQueue.main.async {
                    self?.allTrails = loadedTrails
                    self?.hasLoadedData = true
                    self?.lastLoadedDate = Date()
                    self?.isLoading = false
                    print("✅ Loaded \(loadedTrails.count) users into cache")
                }
            } else {
                DispatchQueue.main.async {
                    self?.isLoading = false
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
