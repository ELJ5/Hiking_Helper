//
//  LoadingView.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 12/1/25.
//

import SwiftUI

struct LoadingView: View {
    @State private var isAnimating = false
    var message: String = "Loading..."
    
    var body: some View {
        ZStack {
            // Semi-transparent background
            Color.primaryGreen.opacity(0.6)
                .ignoresSafeArea()
            
            VStack(spacing: 25) {
                // App icon/logo
                Image(systemName: "figure.hiking")
                    .resizable()
                    .frame(width: 80, height: 80)
                    .foregroundColor(.white)
                    .scaleEffect(isAnimating ? 1.1 : 1.0)
                    .animation(.easeInOut(duration: 1).repeatForever(autoreverses: true), value: isAnimating)
                
                Text("Hiking Helper")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle(tint: .darkGreen))
                    .scaleEffect(1.5)
                
                Text(message)
                    .foregroundColor(.white.opacity(0.9))
                    .font(.subheadline)
            }
            .padding(50)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color.white.opacity(0.1))
                    .shadow(radius: 20)
            )
        }
        .onAppear {
            isAnimating = true
        }
    }
}
