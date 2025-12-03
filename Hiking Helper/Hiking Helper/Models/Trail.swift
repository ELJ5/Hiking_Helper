import Foundation

struct Trail: Identifiable, Codable, Hashable {
    let id: Int
    let trailName: String
    let state: String
    let latitude: Double
    let longitude: Double
    let distanceMiles: Double
    let elevationGainFeet: Double
    let difficultyLevel: String
    let terrainTypes: [String]
    let description: String
    let userRating: Double
    let completed: Bool
}
