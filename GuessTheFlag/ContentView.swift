//
//  ContentView.swift
//  GuessTheFlag
//
//  Created by Muhammad Fahmi on 20/08/23.
//

import SwiftUI
import ColorKit

struct ProminentTitle: ViewModifier{
    func body(content: Content) -> some View {
        content
            .font(.largeTitle.weight(.heavy))
            .foregroundStyle(.white)
            .shadow(radius: 2)
    }
}

extension View{
    func prominentTitle() -> some View {
        modifier(ProminentTitle())
    }
}

struct ContentView: View {
    @State private var isAlertScore = false
    @State private var alertMessage = ""
    @State private var flag = ["Estonia", "France", "Germany", "Ireland", "Italy", "Monaco", "Nigeria", "Poland", "Russia", "Spain", "UK", "US"].shuffled()
    @State private var correctAnswer = Int.random(in: 0...2)
    @State private var userAnswer = 0
    @State private var score = 0
    @State private var isFinish = false
    @State private var tapCount = 0
    
    @State private var animationAmount = 0.0
    @State private var opacityAmount = 1.0
    @State private var scaleAmount = 1.0
    
    struct FlagImage: View {
        let flag: String
        var body: some View{
            Image(flag)
                .renderingMode(.original)
                .clipShape(Capsule())
                .shadow(radius: 5)
                .opacity(1)
        }
    }
    
    var body: some View {
        ZStack{
            RadialGradient(stops:[
                .init(color: Color(uiColor: UIColor(hex: "393E46") ?? .black), location: 0.4),
                .init(color: Color(uiColor: UIColor(hex: "00ADB5") ?? .black), location:0.4)
            ], center: .top, startRadius: 200, endRadius: 700)
            .ignoresSafeArea()
            VStack{
                Text("Guess the flag")
                    .prominentTitle() // custom modifier
                Spacer()
                Spacer()

                VStack(spacing: 30){
                    VStack{
                        Text("Tap the flag of")
                            .font(.subheadline.weight(.heavy))
                        Text(flag[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    ForEach(0..<3){ number in
                        Button(){
                            flagTapped(number)
                            userAnswer = number
                            withAnimation(.easeInOut(duration: 1)){
                                scaleAmount = 0
                                opacityAmount = 0
                                animationAmount += 360
                            }
                            print("userAnswer was \(userAnswer)")
                            print("number: \(number)")
                            print("\(opacityAmount)")
                        } label: {
                            FlagImage(flag: flag[number]) // custom view with specific modifiers
                        }
                        .rotation3DEffect(.degrees(number == userAnswer ? animationAmount : 0), axis: (x: 0, y: 1, z: 0))
                        .opacity(number != userAnswer ? opacityAmount : 1)
                        .scaleEffect(number != userAnswer ? scaleAmount : 1 )
                        
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.ultraThinMaterial)
                .clipShape(RoundedRectangle(cornerRadius: 20))
                Spacer()
                Text("Score: \(score)")
                    .font(.largeTitle.bold())
                    .foregroundStyle(.white)
                Spacer()
            }
            .padding()
        }
        .alert(alertMessage, isPresented: $isAlertScore){
            Button("Continue", action: askQustion)
        } message: {
            alertMessage == "Correct" ? Text("Score is now \(score)") : Text("Wrong! That’s the flag of \(flag[userAnswer])")
        }
        .alert("Game over", isPresented: $isFinish){
            Button("Restart the game", action: reset)
        } message: {
            Text("Your final score is \(score)")
        }
        
    }
    func flagTapped(_ number: Int) {
        if number == correctAnswer{
            alertMessage = "Correct"
            score += 1
        } else {
            alertMessage = "Wrong"
        }
        tapCount += 1
        if tapCount == 8{
            isFinish = true
            tapCount = 0
        }
        isAlertScore = true
    }
    
    func askQustion(){
        withAnimation{
            scaleAmount = 1
            opacityAmount = 1
            flag.shuffle()
            correctAnswer = Int.random(in: 0...2)
        }
    }
    func reset() {
        score = 0
        isAlertScore = false
        isFinish = false
        askQustion()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

//extension Color {
//    init(hex: String) {
//        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines)
//        hexSanitized = hexSanitized.replacingOccurrences(of: "#", with: "")
//
//        var rgb: UInt64 = 0
//
//        Scanner(string: hexSanitized).scanHexInt64(&rgb)
//
//        let red = Double((rgb >> 16) & 0xFF) / 255.0
//        let green = Double((rgb >> 8) & 0xFF) / 255.0
//        let blue = Double(rgb & 0xFF) / 255.0
//
//        self.init(red: red, green: green, blue: blue)
//    }
//}

//let agents = ["Cyril", "Lana", "Pam", "Sterling"]
//
//ForEach(0 ..< 100) { number in
//    Text("Row \(number)")
//}
//
//ForEach(agents, id: \.self) {
//    Text("Agents: \($0)")
//}
