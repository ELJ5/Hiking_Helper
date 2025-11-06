import SwiftUI

struct TestHomeView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var userPreferences: UserPreferences
    
    var body: some View {
        NavigationView {
            VStack {
                if dataManager.isLoading {
                    ProgressView("Loading trails...")
                } else {
                    List(dataManager.filteredTrails) { hike in
                        HikeRowView(hike: hike)
                    }
                }
            }
            .navigationTitle("Recommended Trails")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink(destination: SettingsView()) {
                        Image(systemName: "gear")
                    }
                }
            }
        }
    }
}
