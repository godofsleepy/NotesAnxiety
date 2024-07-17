//
//  AnxietyTrackerView.swift
//  NotesAnxiety
//
//  Created by Sena Kristiawan on 16/07/24.
//

import SwiftUI

struct AnxietyTrackerView: View {
    @State private var isTapped = false
    @State private var buttonText = "Next"
    
    var body: some View {
        HStack{
            Button(action: {
                
            }){
                AnxietyLevelComponent(image: isTapped ? "cloud.circle.fill" : "cloud.circle", text: "Minimal", color: .init(red: 140, green: 165, blue: 233))
            }
            Button(action: {}){
                AnxietyLevelComponent(image: isTapped ? "cloud.drizzle.circle.fill" : "cloud.drizzle.circle", text: "Mild", color: .init(red: 103, green: 130, blue: 205))
            }
            Button(action: {}){
                AnxietyLevelComponent(image: isTapped ? "cloud.heavyrain.circle.fill" : "cloud.heavyrain.circle", text: "Moderate", color: .init(red: 69, green: 95, blue: 165))
            }
            Button(action: {}){
                AnxietyLevelComponent(image: isTapped ? "cloud.bolt.circle.fill" : "cloud.bolt.circle", text: "Severe", color: .init(red: 46, green: 66, blue: 121))
            }
            
            Button(action: {
                buttonText = "Submit"
                
            }){
                Text(buttonText)
            }
        }
        
        .frame(width: 1000, height: 200)
        
//        .background(Color.white)
        
        
    }
}

#Preview {
    AnxietyTrackerView()
}
