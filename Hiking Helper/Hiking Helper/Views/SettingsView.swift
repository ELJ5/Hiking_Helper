//Eliana Johnson

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var userPreferences: UserPreferences
    @EnvironmentObject var dataManager: DataManager
    
    @State private var difficulty: String
    @State private var minDistance: Double
    @State private var maxDistance: Double
    @State private var elevation: String
    @State private var helper: Bool
    
    init() {
        let prefs = UserPreferences.load()
        _difficulty = State(initialValue: String(prefs.difficulty))
        _minDistance = State(initialValue: Double(prefs.minDistance))
        _maxDistance = State(initialValue: Double(prefs.maxDistance))
        _elevation = State(initialValue: String(prefs.elevation))
        _helper = State(initialValue: Bool(prefs.helper))
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Distance Preference")) {
                    VStack(alignment: .leading) {
                        Text("Minimum Distance: \(Double(minDistance))")
                        Slider(value: $maxDistance, in: 0.5...50, step: 1)
                    }
                    
                    VStack(alignment: .leading) {
                        Text("Maximum Distance: \(Double(maxDistance))")
                        Slider(value: $maxDistance, in: 0.5...50, step: 1)
                    }
                }
                
//                Section(header: Text("Interests")) {
//                    ForEach(availableInterests, id: \.self) { interest in
//                        Button(action: {
//                            if selectedInterests.contains(interest) {
//                                selectedInterests.remove(interest)
//                            } else {
//                                selectedInterests.insert(interest)
//                            }
//                        }) {
//                            HStack {
//                                Text(interest)
//                                    .foregroundColor(.primary)
//                                Spacer()
//                                if selectedInterests.contains(interest) {
//                                    Image(systemName: "checkmark")
//                                        .foregroundColor(.blue)
//                                }
//                            }
//                        }
//                    }
//                }
                
//                Section(header: Text("Location")) {
//                    TextField("Enter your location", text: $location)
//                }
                
                Section {
                    Button("Save Changes") {
                        savePreferences()
                    }
                    .frame(maxWidth: .infinity)
                    
                    Button("Reset to Defaults", role: .destructive) {
                        userPreferences.reset()
                        loadCurrentPreferences()
                    }
                }
                
                Section(header: Text("Data")) {
                    HStack {
                        Text("Trails loaded")
                        Spacer()
                        Text("\(dataManager.allTrails.count)")
                            .foregroundColor(.secondary)
                    }
                    
                    if let date = dataManager.lastLoadedDate {
                        HStack {
                            Text("Last updated")
                            Spacer()
                            Text(date, style: .relative)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Button("Refresh Data") {
                        dataManager.refresh()
                    }
                }
            }
            .navigationTitle("Settings")
        }
        .onAppear {
            loadCurrentPreferences()
        }
    }
    
    private func loadCurrentPreferences() {
        let prefs = userPreferences.trailPreferences
        difficulty = String(prefs.difficulty)
        minDistance = Double(prefs.minDistance)
        maxDistance = Double(prefs.maxDistance)
        elevation = String(prefs.elevation)
        helper = Bool(prefs.helper)
    }
    
    private func savePreferences() {
        let prefs = userPreferences.trailPreferences
        difficulty = String(prefs.difficulty)
        minDistance = Double(prefs.minDistance)
        maxDistance = Double(prefs.maxDistance)
        elevation = String(prefs.elevation)
        helper = Bool(prefs.helper)
        
        userPreferences.trailPreferences = prefs
        
        // Filtered data automatically updates via computed property
        // No need to reload the entire dataset!
    }
}
#Preview {
    SettingsView()
        .environmentObject(UserPreferences())
        .environmentObject(DataManager(userPreferences: UserPreferences()))
}
