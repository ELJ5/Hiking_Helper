//
//  HomeView.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 10/16/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var userPreferences: UserPreferences
    @EnvironmentObject var dataManager: DataManager
    
    @State private var navigateToProfile = false
    @State private var navigateToChatbot = false
    @State private var goals: [String] = ["Hike 4 times", "hike 200 miles", "get boots", "hike a new hike", "test scroll", "test again"]
    
    var body: some View {
            VStack(spacing: 0) {
                // Header with buttons
                HStack {
                    Button(action: {
                        navigateToChatbot = true
                    }) {
                        Image(systemName: "message.fill")
                            .font(.title)
                            .foregroundColor(.green)
                            .padding(.leading, 20)
                            .padding(.top, 10)
                    }
                    .navigationDestination(isPresented: $navigateToChatbot) {
                        ChatbotView()
                            .environmentObject(userPreferences)
                            .environmentObject(dataManager)
                    }

                    
                    Spacer()
                    
                    Button(action: {
                        navigateToProfile = true
                        print("hit button")
                    }) {
                        Image(systemName: "person.fill")
                            .font(.title)
                            .foregroundColor(.blue)
                            .padding(.trailing, 20)
                            .padding(.top, 10)
                    }
                    .navigationDestination(isPresented: $navigateToProfile) {
                        ProfileView()
                            .environmentObject(userPreferences)
                            .environmentObject(dataManager)
                    }
                }
                .padding(.bottom, 10)
                
                // Main content
                ScrollView {
                    VStack(spacing: 20) {
                        // Progress and Checklist section
                        HStack(alignment: .top, spacing: 20) {
                            // Progress Circle
                            VStack {
                                Text("Progress")
                                    .font(.headline)
                                Text("75%")
                                    .font(.title2)
                                    .bold()
                                
                                ZStack {
                                    Circle()
                                        .stroke(Color.gray.opacity(0.2), lineWidth: 10)
                                    
                                    Circle()
                                        .trim(from: 0, to: 0.75)
                                        .stroke(.green, lineWidth: 10)
                                        .rotationEffect(.degrees(-90))
                                }
                                .frame(width: 125, height: 125)
                                .padding()
                            }
                            
                            // Checklist
                            VStack {
                                Text("CheckList")
                                    .font(.headline)
                                
                                ScrollView {
                                    VStack(alignment: .leading, spacing: 10) {
                                        ForEach(goals, id: \.self) { item in
                                            HStack {
                                                Image(systemName: "circle")
                                                    .foregroundColor(.green)
                                                Text(item)
                                                    .font(.subheadline)
                                            }
                                        }
                                    }
                                    .padding()
                                }
                                .frame(height: 200)
                                .background(
                                    RoundedRectangle(cornerRadius: 15)
                                        .fill(Color(.systemGray6))
                                )
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(.horizontal)
                        
                        // Nearby Hikes section
                        VStack {
                            Text("Nearby Hikes")
                                .font(.title2)
                                .bold()
                                .padding(.top, 20)
                            
                            // Placeholder for map
                            ZStack {
                                RoundedRectangle(cornerRadius: 15)
                                    .fill(Color(.systemGray6))
                                    .frame(height: 300)
                                
                                VStack {
                                    Image(systemName: "map.fill")
                                        .font(.system(size: 60))
                                        .foregroundColor(.green)
                                    Text("Map Coming Soon")
                                        .font(.caption)
                                        .foregroundColor(.secondary)
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                    .padding(.top, 10)
                }
            }
            .navigationBarHidden(true)  // ✅ Hide default navigation bar
        }
    }


#Preview {
    let prefs = UserPreferences()
    let dataManager = DataManager(userPreferences: prefs)
    
    return HomeView()
        .environmentObject(prefs)
        .environmentObject(dataManager)
}
