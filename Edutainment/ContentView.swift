//
//  ContentView.swift
//  Edutainment
//
//  Created by James Cao on 3/17/25.
//

import SwiftUI

struct ContentView: View {
    
    // the multiplication factor being practiced, ranges from 2 to 12
    @State var factorNum = 2
    @State var randNum = Int.random(in: 2..<12)
    @State var correctAnswer = 0
    
    // # of questions to ask, 5 or 10 or 20
    @State var numQuestions = 5
    let questionRange = [5, 10, 20]
    @State var currentQuestion = 0
    
    // user input answer
    @State var inputAnswer = 0
    @State var correctAnswers = 0
    
    // alert show states
    @State var showScore = false
    @State var gameOver = false
    
    // after submitting an answer, alert contents
    @State var solutionMessage = ""
    
    var body: some View {
        
        NavigationStack {
            
            ZStack {
                
                // complete background colot
                LinearGradient(colors: [.cyan, .yellow], startPoint: .top, endPoint:.bottom)
                    .ignoresSafeArea()
                
                // main contents of app
                VStack {
                    
                    // settings
                    VStack {
                        Text("Multiplication factor to practice:")
                            .font(.title3)
                        Stepper("Factor: \(factorNum)", value: $factorNum, in: 2...12, step: 1)
                            .frame(maxWidth: 200)
                        
                        Spacer()
                            .frame(height: 40)
                        
                        Text("Number of questions:")
                            .font(.title3)
                        Picker("", selection: $numQuestions) {
                            ForEach(questionRange, id: \.self) {
                                Text(String($0))
                            }
                        }
                        .pickerStyle(.segmented)
                        .frame(maxWidth: 200)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 20)
                    .background(.regularMaterial)
                    .clipShape(.rect(cornerRadius: 20))
                    
                    // question, score, reset button
                    VStack {
                        Spacer()
                        
                        // min() ensures question num displayed doesn't pass numQuestions
                        Text("Question: \(min(currentQuestion + 1, numQuestions)) of \(numQuestions)")
                        
                        Text("What is \(factorNum) x \(randNum)?")
                            .font(.title2)
                            .bold()
                        
                        TextField("Answer", value: $inputAnswer, format: .number)
                            .textFieldStyle(.roundedBorder)
                            .onSubmit{checkAnswer()}
                            .frame(maxWidth: 200)
                            .alert("And your answer is ...", isPresented: $showScore){
                                Button("Continue", action: setQuestion)
                            } message: {
                                Text(solutionMessage)
                            }
                            .alert("Game Over", isPresented: $gameOver){
                                Button("Play Again", action: restart)
                            } message: {
                                Text("Your Final Score is \(correctAnswers)/\(numQuestions)")
                            }
                        
                        Spacer()
                        
                        Text("Current Score: \(correctAnswers) out of \(numQuestions) correct.")
                        
                        Button("Restart Game") {
                            restart()
                        }
                        .padding()
                        .tint(.white)
                        .background(LinearGradient(colors: [.orange, .red], startPoint: .top, endPoint:.bottom))
                        .fontWeight(.bold)
                        .clipShape(.capsule)
                        
                    }
                    .padding()
                    
                    Spacer()
                    
                } // VStack that contains all of the main components
                .navigationTitle("Edutainment")
                .padding()
                
            } // ZStack for background
            
        } // NavigationStack
        
    }
    
    // sets up the next question, reseting certain variables and checking if game is over
    func setQuestion() {
        currentQuestion += 1
        correctAnswer = 0
        inputAnswer = 0
        
        if currentQuestion < numQuestions {
            // set up next question
            randNum = Int.random(in: 0..<15)
        }
        else {
            // final question has been answered, trigger gameover screen
            gameOver = true
        }
    }
    
    // checks if input answer is correct
    func checkAnswer() {
        correctAnswer = factorNum * randNum
        
        if inputAnswer == correctAnswer {
            correctAnswers += 1
            solutionMessage = "... correct!"
        } else {
            solutionMessage = "... incorrect! The correct answer is \(correctAnswer)."
        }
        
        // this makes more sense here, but moved to setQuestion so that the display doesn't change question number until after closing alert
//        currentQuestion += 1
        showScore = true
    }
    
    func restart() {
        correctAnswers = 0
        inputAnswer = 0
        currentQuestion = 0
        correctAnswer = 0
        gameOver = false
    }
    
}

#Preview {
    ContentView()
}
