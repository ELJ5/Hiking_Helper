//
//  ProfileView.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 10/16/25.
//

import SwiftUI
struct Trail: Identifiable{
    let id = UUID()
    let name: String
    let difficulty: String
    let durationHours:Double
    let distanceTravel:String
}

struct ProfileView: View {
    @State private var filteredTrails: [Trail] = []
    @State private var navigateToHome = false
    @State private var navigateToSettings = false
    @State private var preferences: [String: String] = ["Difficulty": "Easy", "Milage" : "4-6", "Helper" : "Active"]
    
    
    //sample data
    let allTrails = [
        Trail(name:"EasyLoop", difficulty:"Easy", durationHours:1.0, distanceTravel: "0-2 miles"),
        Trail(name:"MidLoop", difficulty:"Moderate", durationHours:2.0, distanceTravel: "2-4 miles"),
        Trail(name:"HardLoop", difficulty:"Hard", durationHours:4.0, distanceTravel: "6+ miles"),
        Trail(name:"coolLoop", difficulty:"Moderate", durationHours:3.5, distanceTravel: "4-6 miles")
    ]
    
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
                    .onAppear(perform: filterTrails)
                    
                }

            }
            
            
            .frame(maxHeight: .infinity, alignment: .top)
            .padding()
        }
    
    func filterTrails() {
        let answers = QuestionnaireManager.loadAnswers()
        let preferredDifficulty = answers["Which difficulty level do you prefer?"]
        
        let ableDistance = answers["How far do you think you can hike right now?"]
        
        if let pref = preferredDifficulty{
            filteredTrails = allTrails.filter { $0.difficulty == pref}
        } else {
            filteredTrails = allTrails
        }
        
        if let pref = ableDistance{
            filteredTrails = allTrails.filter {$0.distanceTravel == pref}
        } else {
            filteredTrails = allTrails
        }
    }

}



#Preview {
    ProfileView()
}
