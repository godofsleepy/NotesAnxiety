//
//  LogView.swift
//  Notessss
//
//  Created by Sena Kristiawan on 17/07/24.
//

import SwiftUI

struct LogView: View {
    @Binding var showAnxiety: Bool
    @State var value: Double = 1
    @State private var previousSliderValue: Double = 0.0

    @State var labels: String = "minimals"
    @State private var anxietyStatus : AnxietyState = .minimals
    @State private var bgRed : Double = 140
    @State private var bgGreen : Double = 165
    @State private var bgBlue : Double = 223
    var body: some View {
        
        VStack(alignment: .center){
            
            HStack{
                Text("Choose how you're feeling right now")
                    .fontWeight(.semibold)
                    .font(.system(size: 16))
                Spacer()
                Button(action: {
                    self.showAnxiety.toggle()
                }){
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(Color(red: 118/255, green: 118/255, blue: 128/255).opacity(0.32))
                }
                .font(.system(size: 22))
                
            }
            .padding(EdgeInsets(top: 12, leading: 0, bottom: 25, trailing: 0))
            
            VStack{
                LogComponent(label: labels, state: anxietyStatus)
                VStack {
                    Slider( value: self.$value, in: 1...4)
                    
                        .accentColor(Color.gray)
                        .padding(4)
                }
                .background(Color(red: 118/255, green: 118/255, blue: 128/255).opacity(0.32))
                .cornerRadius(50)
                .frame(width:325, height: 40)
                .padding(EdgeInsets(top: 15, leading: 0, bottom: 10, trailing: 0))
                
                
                NavigationLink(destination: CategoryView(bgRed: self.bgRed, bgGreen: self.bgGreen, bgBlue: self.bgBlue, anxietyLevel: $value), label: {
                    Text("Next")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                })
                Spacer()
            }
            .padding()
            
            
        }
        .padding()
        .background(
            RadialGradient(colors: [
                Color(red: bgRed/255, green: bgGreen/255, blue: bgBlue/255), Color.white],
                           center: .center, startRadius: 5, endRadius: 400).opacity(0.75)
        )
        .onChange(of: value) {
            if value < previousSliderValue {
                self.bgRed = min(140, self.bgRed + 1)
                print("red up: \(self.bgRed)")
                self.bgGreen = min(165, self.bgGreen + 1)
                print("green up: \(self.bgGreen)")
                self.bgBlue = min(223, self.bgBlue + 1)
                print("blue up: \(self.bgBlue)")
            } else if value > previousSliderValue {
                self.bgRed = max(16, self.bgRed - 1)
                print("red down: \(self.bgRed)")
                self.bgGreen = max(35, self.bgGreen - 1)
                print("green down: \(self.bgGreen)")
                self.bgBlue = max(84, self.bgBlue - 1)
                print("blue down: \(self.bgBlue)")
            }
            // Update the previous value
            previousSliderValue = value
            
            if self.value > 3.5 && self.value <= 4 {
                anxietyStatus = .severe
                self.labels = "Severe"
            } else if self.value > 2.5 && self.value <= 3.5 {
                anxietyStatus = .moderate
                self.labels = "Moderate"
            } else if self.value > 1.5 && self.value <= 2.5 {
                anxietyStatus = .mild
                self.labels = "Mild"
            } else {
                anxietyStatus = .minimals
                self.labels = "Minimals"
            }
        }
        
    }
}

//#Preview {
//    LogView(value: .constant(200))
//}
