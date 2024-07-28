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
    @State private var previousSliderValue: Double = 1.0
    @State var anxietyLevelType: AnxietyLevelType = AnxietyLevelType.from(1.0)
    
    var body: some View {
        
        VStack(alignment: .center){
            Text("Choose how you're feeling right now")
                .frame(width: 300, alignment: .center)
                .multilineTextAlignment(.center)
                .fontWeight(.bold)
                .font(.title2)
                .foregroundStyle(Color.white)
                .padding(.top)
            
            VStack{
                LogComponent(anxietyLevelType: anxietyLevelType)
                VStack {
                    Slider( value: self.$value, in: 1...4)
                        .tint(Color.clear)
                        .accentColor(Color.clear)
                        .padding(4)
                }
                
                .background(Color(red: 118/255, green: 118/255, blue: 128/255).opacity(0.32))
                .cornerRadius(25)
                .frame(width:325, height: 40)
                .padding(.bottom)
                
                Spacer()
                NavigationLink(destination: CategoryView(anxietyLevelType: $anxietyLevelType, showAnxiety: $showAnxiety), label: {
                    Text("Next")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(anxietyLevelType.color)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                })
                .padding(.bottom)
            }
            .padding()
            
            
        }
        .padding()
        .background(
            RadialGradient(colors: [
                Color(anxietyLevelType.color!), Color.backgroundSecondary
            ], center: .center, startRadius: 5, endRadius: 400)
        )
        .onChange(of: value) {
            withAnimation(.easeInOut(duration: 0.5)) {
                anxietyLevelType = AnxietyLevelType.from(value)
            }
        }
        .toolbar{
            ToolbarItem(placement: .topBarTrailing){
                Button(action: {
                    showAnxiety = false
                }, label: {
                    Text("Cancel")
                        .foregroundStyle(Color.white)
                })
            }
        }
    }
}

//#Preview {
//    LogView(value: .constant(200))
//}
