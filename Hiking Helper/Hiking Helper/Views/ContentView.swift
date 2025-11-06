//
//  ContentView.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 10/4/25.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var userPreferences: UserPreferences
    
    var body: some View {
        TabView {
            ProfileView()
                .tabItem {
                    Label("Users", systemImage: "person.3")
                }
            
            SettingsView()
                .tabItem {
                    Label("Settings", systemImage: "gear")
                }
        }
    }
}

#Preview {
    ContentView()
}
