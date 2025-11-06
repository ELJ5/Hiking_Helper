import Foundation

struct Trail: Identifiable, Codable {
    let id: UUID
    let trailName: String
    let state: String
    let latitude: Float
    let longitude: Float
    let distanceMiles: Double
    let elevationGainFeet: Float
    let difficultyLevel: String
    let terrainTypes: String
    let description: String
    let userRating: Float
}
