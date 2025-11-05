//
//  QuestionnaireView.swift
//  Hiking Helper
//
//  Created by Eliana Johnson on 10/18/25.
//

import Foundation
import SwiftUI

struct QuestionnaireView: View {
    @State private var questions: [Question] = []
    @State private var showResults = false
    @State private var navigateToResults = false
    @State private var currentQuestion = 0
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading, spacing: 20) {
                Text("Hiking Questionnaire")
                    .font(.largeTitle)
                    .bold()
                    .padding(.bottom, 10)
                
                if !questions.isEmpty {
                    // Current question
                    let question = questions[currentQuestion]
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("Question \(currentQuestion + 1) of \(questions.count)")
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        
                        Text(question.text)
                            .font(.headline)
                            .multilineTextAlignment(.leading)
                        
                        ForEach(question.options, id: \.self) { option in
                            Button(action: {
                                questions[currentQuestion].selectedOption = option
                                QuestionnaireManager.save(questions)
                            }) {
                                HStack {
                                    Image(systemName: question.selectedOption == option ? "circle.inset.filled" : "circle")
                                        .foregroundColor(.blue)
                                    Text(option)
                                        .foregroundColor(.primary)
                                }
                                .padding(.vertical, 6)
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(10)
                    .shadow(radius: 2)
                }
                
                Spacer()
                
                // Navigation buttons
                HStack {
                    if currentQuestion > 0 {
                        Button("Back") {
                            withAnimation {
                                currentQuestion -= 1
                            }
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.gray.opacity(0.2))
                        .cornerRadius(10)
                    }
                    
                    Button(currentQuestion == questions.count - 1 ? "Submit" : "Next") {
                        withAnimation {
                            if currentQuestion < questions.count - 1 {
                                currentQuestion += 1
                            } else {
                                submitAnswers()
                            }
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(10)
                }
                .padding(.top, 10)
                
                // Alert
                .alert("Thank you!", isPresented: $showResults) {
                    Button("OK", role: .cancel) { }
                } message: {
                    Text("Your responses have been saved locally.")
                }
            }
            .padding()
            .onAppear(perform: loadQuestions)
            .navigationDestination(isPresented: $navigateToResults) {
                HomeView()
            }
        }
    }

    //Functions
    func loadQuestions() {
        if let saved = QuestionnaireManager.load() {
            questions = saved
        } else {
            questions = [
                Question(id: UUID(), text: "How can Hiking Helper Assist you?", options: ["I'm new to hiking and need the basics", "I have a dream hike I want to do", "Just want help finding trails (helper can be deactivated)"]),
                
                Question(id: UUID(), text: "How often do you hike?", options: ["Never have", "Once a year", "Every 6-12 months", "Every other month", "Every Month", "Almost Weekly"]),
                
                Question(id: UUID(), text: "How far do you want to hike?", options: ["0-2 miles", "2-4 miles", "4-6 miles", "6+ miles"]),
                
                Question(id: UUID(), text: "How far do you think you can hike right now?", options: ["0-2 miles", "2-4 miles", "4-6 miles", "6+ miles"]),
                
                Question(id: UUID(), text: "Thank you for sharing! Do you mind sharing your location so we can find hikes near you?", options: ["No thank you", "Sure!"]),
                
                Question(id: UUID(), text: "No worries. What city is near you?", options: ["Don't share city", "input"]),
                
                Question(id: UUID(), text: "How far are you willing to go from your location for a trail?", options: ["<60 miles", "60-100 miles", "100-125 miles", "125-250 miles", "250+ miles"]),
                
                Question(id: UUID(), text: "Are you ready to explore?!", options: ["Yes!", "Can't Wait!"])
            ]
        }
    }
    
    func submitAnswers() {
        QuestionnaireManager.save(questions)
        showResults = true
        navigateToResults = true
        print("✅ Responses saved locally.")
    }
}

#Preview {
    QuestionnaireView()
}
