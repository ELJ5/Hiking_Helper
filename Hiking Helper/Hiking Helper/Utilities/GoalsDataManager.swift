import Foundation
import Combine

class GoalDataManager: ObservableObject {
    
    // MARK: - Published Properties
    @Published private(set) var goals: [Goal] = []
    @Published private(set) var isLoading: Bool = false
    @Published private(set) var errorMessage: String?
    
    private let openAIService = OpenAIService()
    
    // MARK: - Private Properties
    private let userDefaultsKey = "savedHikingGoals"
    private let fileManager = FileManager.default
    
    // MARK: - Computed Properties
    var completedGoals: [Goal] {
        goals.filter { $0.isCompleted }
    }
    
    var pendingGoals: [Goal] {
        goals.filter { !$0.isCompleted }
    }
    
    var completionPercentage: Double {
        guard !goals.isEmpty else { return 0 }
        return Double(completedGoals.count) / Double(goals.count) * 100
    }
    
    var goalsByCategory: [GoalCategory: [Goal]] {
        Dictionary(grouping: goals, by: { $0.category })
    }
    
    // MARK: - Initialization
    init() {
        loadGoals()
    }
    
    /// Initialize with test data for previews
    init(withTestData: Bool) {
        if withTestData {
            self.goals = Goal.sampleGoals
        } else {
            loadGoals()
        }
    }
    
    // MARK: - AI Goal Generation
    
    func generateGoals(from preferences: TrailPreferences, timeframe: GoalTimeframe) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            // Create UserPreferences wrapper
            let userPrefs = UserPreferences()
            userPrefs.trailPreferences = preferences
            
            let newGoals = try await openAIService.generatePersonalizedGoals(
                userPreferences: userPrefs,
                timeframe: timeframe
            )
            
            await MainActor.run {
                self.goals.append(contentsOf: newGoals)  // Add new goals to existing
                saveGoals()
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    // Optional: Replace all goals instead of appending
    func regenerateAllGoals(from preferences: TrailPreferences, timeframe: GoalTimeframe) async {
        await MainActor.run {
            isLoading = true
            errorMessage = nil
        }
        
        do {
            let userPrefs = UserPreferences()
            userPrefs.trailPreferences = preferences
            
            let newGoals = try await openAIService.generatePersonalizedGoals(
                userPreferences: userPrefs,
                timeframe: timeframe
            )
            
            await MainActor.run {
                self.goals = newGoals  // Replace all goals
                saveGoals()
                isLoading = false
            }
        } catch {
            await MainActor.run {
                errorMessage = error.localizedDescription
                isLoading = false
            }
        }
    }
    
    // MARK: - CRUD Operations
    
    func addGoal(_ goal: Goal) {
        goals.append(goal)
        saveGoals()
    }
    
    func addGoals(_ newGoals: [Goal]) {
        goals.append(contentsOf: newGoals)
        saveGoals()
    }
    
    func updateGoal(_ goal: Goal) {
        if let index = goals.firstIndex(where: { $0.id == goal.id }) {
            goals[index] = goal
            saveGoals()
        }
    }
    
    func deleteGoal(id: UUID) {
        goals.removeAll { $0.id == id }
        saveGoals()
    }
    
    func deleteGoals(at offsets: IndexSet) {
        goals.remove(atOffsets: offsets)
        saveGoals()
    }
    
    func toggleGoalCompletion(id: UUID) {
        if let index = goals.firstIndex(where: { $0.id == id }) {
            goals[index].toggleCompletion()
            saveGoals()
        }
    }
    
    func clearAllGoals() {
        goals.removeAll()
        saveGoals()
    }
    
    func replaceAllGoals(with newGoals: [Goal]) {
        goals = newGoals
        saveGoals()
    }
    
    // MARK: - Filtering & Sorting
    
    func goals(for category: GoalCategory) -> [Goal] {
        goals.filter { $0.category == category }
    }
    
    func goals(for timeframe: GoalTimeframe) -> [Goal] {
        goals.filter { $0.timeframe == timeframe }
    }
    
    func goals(completed: Bool) -> [Goal] {
        goals.filter { $0.isCompleted == completed }
    }
    
    func goalsSortedByDate(ascending: Bool = false) -> [Goal] {
        goals.sorted {
            ascending ? $0.createdAt < $1.createdAt : $0.createdAt > $1.createdAt
        }
    }
    
    func goalsSortedByCompletion() -> [Goal] {
        goals.sorted { !$0.isCompleted && $1.isCompleted }
    }
    
    // MARK: - Persistence
    
    private func saveGoals() {
        do {
            let encoded = try JSONEncoder().encode(goals)
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
            errorMessage = nil
        } catch {
            errorMessage = "Failed to save goals: \(error.localizedDescription)"
        }
    }
    
    private func loadGoals() {
        guard let data = UserDefaults.standard.data(forKey: userDefaultsKey) else {
            goals = []
            return
        }
        
        do {
            goals = try JSONDecoder().decode([Goal].self, from: data)
            errorMessage = nil
        } catch {
            errorMessage = "Failed to load goals: \(error.localizedDescription)"
            goals = []
        }
    }
    
    // MARK: - Statistics
    
    func getStatistics() -> GoalStatistics {
        GoalStatistics(
            totalGoals: goals.count,
            completedGoals: completedGoals.count,
            pendingGoals: pendingGoals.count,
            completionRate: completionPercentage,
            goalsByCategory: goalsByCategory.mapValues { $0.count },
            recentlyCompleted: completedGoals
                .sorted { ($0.completedAt ?? Date.distantPast) > ($1.completedAt ?? Date.distantPast) }
                .prefix(5)
                .map { $0 }
        )
    }
}

// MARK: - Supporting Types

struct GoalStatistics {
    let totalGoals: Int
    let completedGoals: Int
    let pendingGoals: Int
    let completionRate: Double
    let goalsByCategory: [GoalCategory: Int]
    let recentlyCompleted: [Goal]
}

// MARK: - Sample Goals for Previews

extension Goal {
    static let sampleGoals: [Goal] = [
        Goal(
            title: "Complete a 3-mile trail",
            description: "Find and complete a trail between 2.5-3.5 miles to build your base endurance.",
            category: .distance,
            timeframe: .weekly,
            difficulty: .moderate,
            isCompleted: false,
            createdAt: Date()
        ),
        Goal(
            title: "Hike twice this week",
            description: "Get out on the trail at least twice to build consistency in your hiking routine.",
            category: .frequency,
            timeframe: .weekly,
            difficulty: .easy,
            isCompleted: true,
            completedAt: Date().addingTimeInterval(-86400),
            createdAt: Date().addingTimeInterval(-172800)
        ),
        Goal(
            title: "Try a trail with 300ft elevation gain",
            description: "Challenge yourself with moderate elevation to prepare for more difficult hikes.",
            category: .elevation,
            timeframe: .weekly,
            difficulty: .moderate,
            isCompleted: false,
            createdAt: Date().addingTimeInterval(-86400)
        ),
        Goal(
            title: "Explore a new trail system",
            description: "Visit a trail you've never hiked before to expand your hiking knowledge and experience.",
            category: .exploration,
            timeframe: .weekly,
            difficulty: .easy,
            isCompleted: true,
            completedAt: Date().addingTimeInterval(-43200),
            createdAt: Date().addingTimeInterval(-259200)
        ),
        Goal(
            title: "Practice using trail markers",
            description: "Learn to read and follow blazes, cairns, and trail signs for safer navigation.",
            category: .skills,
            timeframe: .weekly,
            difficulty: .easy,
            isCompleted: false,
            createdAt: Date().addingTimeInterval(-172800)
        )
    ]
}
