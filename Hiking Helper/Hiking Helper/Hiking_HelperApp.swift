import SwiftUI

@main
struct HikingHelperApp: App {
    @StateObject private var userPreferences = UserPreferences()
    @StateObject private var dataManager: DataManager
    
    // Add this state to switch views
    @State private var showDebug = false
    
    init() {
        // Create a temporary instance to initialize dataManager
        let tempPreferences = UserPreferences()
        
        // Initialize the StateObject for dataManager
        _dataManager = StateObject(wrappedValue: DataManager(userPreferences: tempPreferences))
    }
    
    var body: some Scene {
        WindowGroup {
            if userPreferences.needsOnboarding {
                    QuestionnaireView()
                        .environmentObject(userPreferences)
                        .environmentObject(dataManager)
                        .onAppear {
                            dataManager.userPreferences = userPreferences
                        }
                } else {
                    HomeView()
                        .environmentObject(userPreferences)
                        .environmentObject(dataManager)
                        .onAppear {
                            dataManager.userPreferences = userPreferences
                            dataManager.loadTrailsIfNeeded()
                        }
                }
            }
        }
    }

