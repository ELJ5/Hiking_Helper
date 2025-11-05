//
//  HomeView.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 10/16/25.
//

import SwiftUI

struct HomeView: View {
    @State private var navigateToProfile = false
    @State private var goals : [String] = ["Hike 4 times", "hike 200 miles", "get boots", "hike a new hike", "test scroll", "test again"]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Button(action: {
                    navigateToProfile = true
                }){
                    Image(systemName: "person.fill") // Your icon make into profile image
                        .font(.title)
                        .padding(.leading, 10)
                        .padding(.top, 10)
                        .padding(.trailing, 20)
                }
                .navigationDestination(isPresented: $navigateToProfile) {
                    ProfileView()
                }
            }
        }
        
        ScrollView{
            VStack{
            
                HStack{
                    VStack{
                        Text("Progress")
                        Text("75%")                    //need progress value based of to do list marked
                        Circle()
                            .trim(from: 0, to: 0.75) // Fills progress % of the circle
                            .stroke(.green, lineWidth: 10)
                            .frame(width: 125, height: 125)
                            .rotationEffect(.degrees(-90))
                            .padding()
                    }
                    
                    VStack{
                        Text("CheckList")
                        ScrollView{
                            VStack(alignment: .leading, spacing: 10) { // Arrange text items vertically
                                ForEach(goals, id: \.self) { item in
                                    Text(item)
                                        .font(.headline)
                                        .padding(.horizontal)
                                }
                            }
                            .padding() // Add padding around the text items
                            .background(
                                RoundedRectangle(cornerRadius: 15, style: .continuous) // The rounded rectangle shape
                                    .fill(Color.white) // Fill the shape with a color
                                    .frame(width: 100, height: 100)
                            )
                            .padding()
                            
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.top, 20)
                
                VStack{
                    Text("Nearby Hikes")
                    //Add interactive map with hikes nearby
                    Image(systemName: "globe")
                        .frame(width:250, height:400)
                        .imageScale(.large)
                    
                }
            }
        }
        
        //add avatar and game features below
    }
}

#Preview {
    HomeView()
}
