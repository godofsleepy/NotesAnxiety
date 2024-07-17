//
//  LogView.swift
//  Notessss
//
//  Created by Sena Kristiawan on 17/07/24.
//

import SwiftUI

struct CategoryView: View {
    @Environment(\.dismiss) var dismiss
    var bgRed: Double
    var bgGreen: Double
    var bgBlue: Double
//    var contoh = Color(red: 118/255, green: 118/255, blue: 128/255).opacity(0.32)
    
    let categories = [
        "Health", "Fitness", "Self-Care", "Hobbies", "Identity", "Spirituality", "Community", "Family", "Friends", "Partner", "Dating", "Tasks", "Work", "Education", "Travel", "Weather", "Current", "Events", "Money"
    ]
    var body: some View {
        VStack(alignment: .center){
            
            HStack{
                Text("What do you think trigger this feeling?")
                    .fontWeight(.semibold)
                    .font(.system(size: 16))
                Spacer()
                Button(action: {
                    dismiss()
                }){
                    Image(systemName: "x.circle.fill")
                        .font(.system(size: 22))
                        .foregroundStyle(Color(red: 118/255, green: 118/255, blue: 128/255).opacity(0.32))
                }
                
            }
            VStack{
//                LazyVGrid(columns: [GridItem(.adaptive(minimum: 80, maximum: 110))], spacing: 10) {
//                    ForEach(categories, id: \.self){
//                        category in
//                        CategoryComponent(title: category)
//                    }
//                }
                VStackLayout(alignment: .center, spacing: 12){
                    VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 12 ){
                        HStack(alignment: .center, spacing: 12) {
                            CategoryComponent(title: "Health")
                            CategoryComponent(title: "Fitness")
                            CategoryComponent(title: "Self-Care")
                        }
                        HStack(alignment: .center, spacing: 12) {
                            CategoryComponent(title: "Hobbies")
                            CategoryComponent(title: "Identity")
                            CategoryComponent(title: "Spirituality")
                        }
                        HStack(alignment: .center, spacing: 12) {
                            CategoryComponent(title: "Community")
                            CategoryComponent(title: "Family")
                            CategoryComponent(title: "Friends")
                        }
                        HStack(alignment: .center, spacing: 12) {
                            CategoryComponent(title: "Weather")
                            CategoryComponent(title: "Partner")
                            CategoryComponent(title: "Dating")
                            CategoryComponent(title: "Tasks")
                        }
                        HStack(alignment: .center, spacing: 12) {
                            CategoryComponent(title: "Work")
                            CategoryComponent(title: "Education")
                            CategoryComponent(title: "Travel")
                        }
                        HStack(alignment: .center, spacing: 12) {
                            CategoryComponent(title: "Current")
                            CategoryComponent(title: "Events")
                            CategoryComponent(title: "Money")
                        }
                    }
                }
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 40, trailing: 0))
                Button(action: {
                
                }, label: {
                    Text("Done")
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color.blue)
                        .fontWeight(.semibold)
                        .foregroundStyle(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        
                })
            }.padding()
        }
        .padding()
        .background(
            RadialGradient(colors: [Color(red: bgRed/255, green: bgGreen/255, blue: bgBlue/255), Color.white], center: .center, startRadius: 5, endRadius: 400).opacity(0.75))
        .navigationBarBackButtonHidden()
        
    }
}

#Preview {
    CategoryView(bgRed: 140, bgGreen: 165, bgBlue: 223)
}
