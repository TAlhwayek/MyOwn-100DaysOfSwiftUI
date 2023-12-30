//
//  ContentView.swift
//  Flag Guesser
//
//  Created by Tony Alhwayek on 12/29/23.
//

// I don't like limiting the game to 8 rounds

import SwiftUI

struct FlagImage: View {
    var image: String
    
    var body: some View {
        Image(image)
            .renderingMode(.original)
            .clipShape(.buttonBorder)
            .shadow(radius: 5)
    }
}

struct ContentView: View {
    
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco",
                                    "Nigeria", "Poland", "Spain", "UK", "US", "Ukraine"].shuffled()
    
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var score = 0
    
    // Alert
    @State private var showAlert = false
    @State private var alertTitle = ""
    @State private var alertMessage = ""
    
    var body: some View {
        ZStack {
            Color.primary
                .ignoresSafeArea()
            
            VStack {
                
                Spacer()
                
                Text("Flag Guesser")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                
                Spacer()
                Spacer()
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of ")
                            .font(.subheadline.bold())
                            .foregroundStyle(.secondary)
                        
                        Text("\(countries[correctAnswer])")
                            .font(.largeTitle.weight(.semibold))
                            .foregroundStyle(.white)
                        
                        
                        ForEach(0..<3) { number in
                            Button {
                                flagTapped(number)
                            } label: {
                                FlagImage(image: countries[number])
                                    .padding(10)
                            }
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                
                Text("Score: \(score)")
                    .font(.title2.bold())
                    .foregroundStyle(.white)
                
                Spacer()
            }
            .padding()
        }
        .alert(alertTitle, isPresented: $showAlert) {
            Button("Continue", action: newRound)
        } message: {
            Text(alertMessage)
        }
    }
    
    func flagTapped(_ number: Int) {
        if number == correctAnswer {
            score += 1
            alertTitle = "Correct!"
            alertMessage = "Good job!\nYour score is: \(score)"
        } else {
            alertTitle = "Incorrect"
            alertMessage = "That's the flag of \(countries[number])"
        }
        showAlert = true
    }
    
    func newRound() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
    }
}

#Preview {
    ContentView()
}
