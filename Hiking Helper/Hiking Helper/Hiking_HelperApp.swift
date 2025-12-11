import SwiftUI

@main
struct HikingHelperApp: App {
    @StateObject private var userPreferences = UserPreferences()
    @StateObject private var dataManager: DataManager
    @State private var isLoading = true
    
    init() {
    
        let prefs = UserPreferences()
        _userPreferences = StateObject(wrappedValue: prefs)
        _dataManager = StateObject(wrappedValue: DataManager(userPreferences: prefs))
    }
    
    var body: some Scene {
        WindowGroup {
            ZStack{
                    ContentView()
                    
                        .environmentObject(userPreferences)
                        .environmentObject(dataManager)
                    
                    if isLoading{
                        LoadingView(message: "Loading Trails")
                            .transition(.opacity)
                    }
                }
                    .onAppear {
                        
                        // Debug: List all JSON files in bundle
                        if let resourcePath = Bundle.main.resourcePath {
                            do {
                                let contents = try FileManager.default.contentsOfDirectory(atPath: resourcePath)
                                let jsonFiles = contents.filter { $0.hasSuffix(".json") }
                                print("JSON files in bundle: \(jsonFiles)")
                            } catch {
                                print("Could not list bundle: \(error)")
                            }
                        }
                        
                        if !userPreferences.needsOnboarding {
                            dataManager.loadTrailsIfNeeded()
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5){
                                withAnimation(.easeOut(duration:0.5)){
                                    isLoading = false
                                }
                            }
                        } else {
                            isLoading = false
                        }
                        
                    }
            }
        }
    }
