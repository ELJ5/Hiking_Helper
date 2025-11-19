import SwiftUI

struct ContentView: View {
    @EnvironmentObject var userPreferences: UserPreferences
    @EnvironmentObject var dataManager: DataManager
    
    var body: some View {
        Group {
            if userPreferences.needsOnboarding {
                QuestionnaireView()
            } else {
                HomeView()
                    .environmentObject(userPreferences)
                    .environmentObject(dataManager)
            }
        }
    }
}

//#Preview {
//    let prefs = UserPreferences()
//    let manager = DataManager()
//    manager.userPreferences = prefs
//    
//    return ContentView()
//        .environmentObject(prefs)
//        .environmentObject(manager)
//}
