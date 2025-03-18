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
            
            VStack {
                
                VStack {
                    Text("Multiplication factor to practice:")
                    Stepper("Factor: \(factorNum)", value: $factorNum, in: 2...12, step: 1)
                }
                .padding()
                
                VStack {
                    Text("Number of questions:")
                    Picker("", selection: $numQuestions) {
                        ForEach(questionRange, id: \.self) {
                            Text(String($0))
                        }
                    }
                    .pickerStyle(.segmented)
                }
                .padding()
                
                VStack {
                    // ensures question num displayed doesn't pass numQuestions
                    Text("Question: \(min(currentQuestion + 1, numQuestions))")
                    Text("What is \(factorNum) x \(randNum)?")
                    TextField("Answer", value: $inputAnswer, format: .number)
                        .onSubmit{checkAnswer()}
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
                }
                .padding()
                
                VStack {
                    Text("\(currentQuestion) out of \(numQuestions) answered.")
                    Button("Restart Game") {
                        restart()
                    }
                }
                
            }
            .navigationTitle("Edutainment")
            .padding()
            
        }
        
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
