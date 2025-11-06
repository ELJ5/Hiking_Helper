//
//  ProfileView.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 10/16/25.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var dataManager: DataManager
    @EnvironmentObject var userPreferences: UserPreferences
    
    @State var difficulty: String
    @State var minDistance: Double
    @State var maxDistance: Double
    @State var elevation: String
    @State var helper: Bool
    
    @State private var filteredTrails: [Trail] = []
    @State private var navigateToHome = false
    @State private var navigateToSettings = false
    @State private var preferences: [String: String] = ["Difficulty": "Easy", "Milage" : "4-6", "Helper" : "Active"]
    

    
    var body: some View {
            VStack {
                HStack {
                    Button(action: {
                        navigateToHome = true
                    }){
                        Image(systemName: "star.fill") // Your icon make into profile image
                            .font(.title)
                            .foregroundColor(.green)
                            .padding(.leading, 10)
                            .padding(.top, 10)
                    }
                    .navigationDestination(isPresented: $navigateToHome) {
                        HomeView()
                    }
                    Spacer()
                    Button(action: {
                        navigateToSettings = true
                    }){
                        Image(systemName: "star.fill") // Your icon make into profile image
                            .font(.title)
                            .foregroundColor(.yellow)
                            .padding(.leading, 10)
                            .padding(.top, 10)
                    }
                    .navigationDestination(isPresented: $navigateToSettings) {
                        SettingsView()
                    }
                }
                
                
                VStack{
                    Image(systemName:"person")   //user image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width:225, height:225)
                        .padding(.top, 20)
                    Text("Username1234")
                        .font(.largeTitle)

                    //Information Stack
                    VStack{
                        HStack{
                            Text("Trails Completed:")
                                .padding(.leading, 20)
                                .padding(.top, 10)
                            Spacer()
                            Text("number")
                                .padding(.trailing, 20)
                                .padding(.top, 10)
                        }
                        HStack{
                            Text("Miles:")
                                .padding(.leading, 20)
                                .padding(.top, 10)
                            Spacer()
                            Text("number")
                                .padding(.trailing, 20)
                                .padding(.top, 10)
                        }
                    }
                    
                    //Filtered Trails stack based on preferences
                    VStack{
                        Text("Preferences")
                            .font(.headline)
                        
                        ForEach(preferences.sorted(by: <), id: \.key) { key, value in
                            HStack{
                                Text("\(key)")
                                    .padding(.leading, 20)
                                    .padding(.top, 10)
                                Text("\(value)")
                                    .padding(.trailing, 20)
                                    .padding(.top, 10)


                            }
                        }
//                        List(filteredTrails) { trail in
//                            Text(trail.name)
//                                .font(.headline)
//                            Text("Difficulty: \(trail.difficulty)")
//                            Text("Distance: \(trail.distanceTravel)")
//                        }
                    }
                    .padding()
//                    .onAppear(perform: filterTrails)
                    
                }

            }
            
            
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
            .onAppear(){
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

    
//    func filterTrails() {
//        let answers = QuestionnaireManager.loadAnswers()
//        let preferredDifficulty = answers["Which difficulty level do you prefer?"]
//        
//        let ableDistance = answers["How far do you think you can hike right now?"]
//        
//        if let pref = preferredDifficulty{
//            filteredTrails = allTrails.filter { $0.difficulty == pref}
//        } else {
//            filteredTrails = allTrails
//        }
//        
//        if let pref = ableDistance{
//            filteredTrails = allTrails.filter {$0.distanceTravel == pref}
//        } else {
//            filteredTrails = allTrails
//        }
//    }

}



#Preview("Profile") {
    let prefs = UserPreferences()
    let dataManager = DataManager(userPreferences: prefs)
    dataManager.userPreferences = prefs
    
    return ProfileView()
        .environmentObject(prefs)
        .environmentObject(dataManager)
}
