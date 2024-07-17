//
//  LogView.swift
//  Notessss
//
//  Created by Sena Kristiawan on 17/07/24.
//

import SwiftUI

struct LogView: View {
    @Binding var showAnxiety: Bool
    @State private var anxityCat = false
    @Binding var value: Double
    @State var lastCoordinateValue: CGFloat = 0.0
    var sliderRange: ClosedRange<Double> = 1...100
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
                GeometryReader { gr in
                    let thumbSize = gr.size.height * 0.8
                    let radius = gr.size.height * 0.5
                    let minValue = gr.size.width * 0.015
                    let maxValue = (gr.size.width * 0.98) - thumbSize
                
                    let scaleFactor = (maxValue - minValue) / (sliderRange.upperBound - sliderRange.lowerBound)
                    let lower = sliderRange.lowerBound
                    let sliderVal = (self.value - lower) * scaleFactor + minValue
                
                    ZStack {
                        RoundedRectangle(cornerRadius: radius)
                            .foregroundColor(Color(red: 118/255, green: 118/255, blue: 128/255).opacity(0.32))
                        HStack {
                            Circle()
                                .foregroundColor(Color.white)
                                .frame(width: thumbSize, height: thumbSize)
                                .offset(x: sliderVal)
                                .gesture(
                                    DragGesture(minimumDistance: 0)
                                        .onChanged { v in
    
                                            print(abs(v.translation.width))
                                            if (abs(v.translation.width) < 0.1) {
                                                self.lastCoordinateValue = sliderVal
                                            }
                                            if v.translation.width > 0 {
                                                let nextCoordinateValue = min(maxValue, self.lastCoordinateValue + v.translation.width)
                                                self.value = ((nextCoordinateValue - minValue) / scaleFactor)  + lower
                                                self.bgRed = max(16, self.bgRed - 1)
                                                print("red down: \(self.bgRed)")
                                                self.bgGreen = max(35, self.bgGreen - 1)
                                                print("green down: \(self.bgGreen)")
                                                self.bgBlue = max(84, self.bgBlue - 1)
                                                print("blue down: \(self.bgBlue)")
                                            
                                                
                                            } else {
                                                let nextCoordinateValue = max(minValue, self.lastCoordinateValue + v.translation.width)
                                                self.value = ((nextCoordinateValue - minValue) / scaleFactor) + lower
                                                self.bgRed = min(140, self.bgRed + 1)
                                                print("red up: \(self.bgRed)")
                                                self.bgGreen = min(165, self.bgGreen + 1)
                                                print("green up: \(self.bgGreen)")
                                                self.bgBlue = min(223, self.bgBlue + 1)
                                                print("blue up: \(self.bgBlue)")
                                                
                    
                                            }
                                            anxietyMeter()
                                        }
                                    )
                            Spacer()
                                    }
                            }
                        }
                .frame(width:325, height: 40)
                .padding(EdgeInsets(top: 15, leading: 0, bottom: 10, trailing: 0))
                //                Slider( value: self.$value, in: 1...100)
                //                    .accentColor(Color.gray)
                //                    .background(GeometryReader{geometry in
                //                        VStack{
                //                        RoundedRectangle(cornerRadius: 25.0)
                //                            .fill(Color.gray.opacity(0.5))
                //                                .frame(height: 20)
                //                                .cornerRadius(2)
                //                                .offset(x:0, y:0)
                //                                .padding(.horizontal, 10)
                //
                //                    }})
                //                    .overlay(
                //                        Circle()
                //                            .fill(Color.red) // Thumb color
                //                            .frame(width: 20, height: 20) // Thumb size
                //                            .overlay(
                //                                Circle()
                //                                    .stroke(Color.white, lineWidth: 2)
                //                            )
                //                            .offset(x:0 , y:-5)
                //                    )
                //                    .padding()
                //
                NavigationLink(destination: CategoryView(bgRed: self.bgRed, bgGreen: self.bgGreen, bgBlue: self.bgBlue), label: {
                    Text("Next")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .foregroundColor(.white) // Use `foregroundColor` instead of `foregroundStyle`
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                })
                Spacer()
            }
            .padding()
            
            
        }
        .padding()
        .background(
            RadialGradient(colors: [Color(red: bgRed/255, green: bgGreen/255, blue: bgBlue/255), Color.white], center: .center, startRadius: 5, endRadius: 400).opacity(0.75)
        
        )
//        .sheet(isPresented: $anxityCat){
//            CategoryView(bgRed: self.bgRed, bgGreen: self.bgGreen, bgBlue: self.bgBlue)
//                .presentationDetents([.height(500)])
//        }
        .onChange(of: bgRed) { _ in anxietyMeter() }
        .onChange(of: bgGreen) { _ in anxietyMeter() }
        .onChange(of: bgBlue) { _ in anxietyMeter() }
    }
    
    func anxietyMeter(){
        if self.bgRed <= 16 && self.bgGreen <= 35 && self.bgBlue <= 84 {
            anxietyStatus = .severe
            self.labels = "Severe"
        } else if self.bgRed <= 61 && self.bgGreen <= 70 && self.bgBlue <= 140 {
            anxietyStatus = .moderate
            self.labels = "Moderate"
        } else if self.bgRed <= 99 && self.bgGreen <= 124 && self.bgBlue <= 192 {
            anxietyStatus = .mild
            self.labels = "Mild"
        } else {
            anxietyStatus = .minimals
            self.labels = "Minimals"
        }
    }
    
}

//#Preview {
//    LogView(value: .constant(200))
//}
