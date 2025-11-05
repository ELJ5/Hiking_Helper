//
//  Trail.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 11/1/25.
//

import Foundation
import SwiftUI

class TrailViewModel: ObservedObject{
    @Published var allTrails: [Trail] = []
    
    init(){
        loadTrails()
    }
    
    private func loadTrails(){
        guard let data = Bundle.main.decode(
            TrailData.self,
            from: "testTrails"
        ) else {
            return
        }
        allTrails = data.trails
    }
    
    // Difficulty filter
    var easyTrails: [Trail] {
        allTrails.filter { $0.difficultyLevel == "Easy" }
    }
    
    var moderateTrails: [Trail] {
        allTrails.filter {$0.difficultyLevel == "Moderate" }
    }
    
    var hardTrails: [Trail] {
        allTrails.filter {$0.difficultyLevel == "Hard" }
    }
    
    //distance filter
    var shortTrails: [Trail] {
        allTrails.filter{ $0.distanceMiles < 3.0 }
    }
    
    var mediumTrails: [Trail] {
        allTrails.filter{ $0.distanceMiles => 3.0 && $0.distanceMiles < 6.0 }
    }
    
    var longTrails: [Trail] {
        allTrails.filter{ $0.distanceMiles => 6.0 }
    }
    
    //elevation filter
    
    var lowElevationTrails: [Trail]{
        allTrails.filter{ $0.elevationGainFeet < 500 }
    }
    
    var highElevationTrails: [Trail]{
        allTrails.filter{ $0.elevationGainFeet => 500 }
    }
    
    func trails(difficulty: String? = nil,
                terrain: String? = nil,
                maxDistance: Double? = nil) -> [Trail]{
        
        var filtered = allTrails
        if let difficulty = difficulty{
            filtered = filtered.filter {$0.difficultyLevel == difficulty }
        }
        if let maxDistance = maxDistance {
            filtered = filtered.filter { $0.distanceMiles <= maxDistance }
        }
        return filtered
    }
}
