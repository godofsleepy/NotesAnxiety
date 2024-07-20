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
            
            HStack{
                Text("Choose how you're feeling right now")
                    .fontWeight(.semibold)
                    .font(.system(size: 16))
                Spacer()
                Button(action: {
                    self.showAnxiety.toggle()
                }){
                    Image(systemName: "x.circle.fill")
                        .foregroundStyle(Color.gray)
                }
                .font(.system(size: 22))
                
            }
            .padding(EdgeInsets(top: 12, leading: 0, bottom: 25, trailing: 0))
            
            VStack{
                LogComponent(anxietyLevelType: anxietyLevelType)
                VStack {
                    Slider( value: self.$value, in: 1...4)
                    
                        .accentColor(Color.gray)
                        .padding(4)
                }
                .background(Color(red: 118/255, green: 118/255, blue: 128/255).opacity(0.32))
                .cornerRadius(25)
                .frame(width:325, height: 40)
                .padding(EdgeInsets(top: 15, leading: 0, bottom: 10, trailing: 0))
                
                
                NavigationLink(destination: CategoryView(anxietyLevelType: $anxietyLevelType), label: {
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
                Color(anxietyLevelType.color!), Color.backgroundSecondary],
                           center: .center, startRadius: 5, endRadius: 300).opacity(0.75)
        )
        .onChange(of: value) {
            withAnimation(.easeInOut(duration: 0.5)) {
                anxietyLevelType = AnxietyLevelType.from(value)
            }
        }
    }
}

//#Preview {
//    LogView(value: .constant(200))
//}
