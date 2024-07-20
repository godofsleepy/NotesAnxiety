//
//  LogView.swift
//  Notessss
//
//  Created by Sena Kristiawan on 17/07/24.
//

import SwiftUI

struct CategoryView: View {
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject() var vm: NotesViewModel
    @Binding var anxietyLevelType: AnxietyLevelType
    @Binding var showAnxiety: Bool
    
    @State var valueCategory: [String] = []
    

    var body: some View {
        VStack(alignment: .center){
            Text("What do you think trigger this feeling?")
                .fixedSize(horizontal: false, vertical: true)
                .lineLimit(nil)
                .frame(width: 300, alignment: .center)
                .multilineTextAlignment(.center)
                .fontWeight(.bold)
                .font(.title2)
                .foregroundStyle(Color.white)
                .padding(.top)
            
            VStack{
                VStackLayout(alignment: .center, spacing: 12){
                    VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: 12 ){
                        HStack(alignment: .center, spacing: 12) {
                            CategoryComponent(value: $valueCategory, title: "Health")
                            CategoryComponent(value: $valueCategory, title: "Fitness")
                            CategoryComponent(value: $valueCategory, title: "Self-Care")
                        }
                        HStack(alignment: .center, spacing: 12) {
                            CategoryComponent(value: $valueCategory,title: "Hobbies")
                            CategoryComponent(value: $valueCategory,title: "Identity")
                            CategoryComponent(value: $valueCategory,title: "Spirituality")
                        }
                        HStack(alignment: .center, spacing: 12) {
                            CategoryComponent(value: $valueCategory,title: "Community")
                            CategoryComponent(value: $valueCategory,title: "Family")
                            CategoryComponent(value: $valueCategory,title: "Friends")
                        }
                        HStack(alignment: .center, spacing: 12) {
                            CategoryComponent(value: $valueCategory,title: "Weather")
                            CategoryComponent(value: $valueCategory,title: "Partner")
                            CategoryComponent(value: $valueCategory,title: "Dating")
                            CategoryComponent(value: $valueCategory,title: "Tasks")
                        }
                        HStack(alignment: .center, spacing: 12) {
                            CategoryComponent(value: $valueCategory,title: "Work")
                            CategoryComponent(value: $valueCategory,title: "Education")
                            CategoryComponent(value: $valueCategory,title: "Travel")
                        }
                        HStack(alignment: .center, spacing: 12) {
                            CategoryComponent(value: $valueCategory,title: "Current")
                            CategoryComponent(value: $valueCategory,title: "Events")
                            CategoryComponent(value: $valueCategory,title: "Money")
                        }
                    }
                }
                .padding(.bottom)
                
                Button(action: {
                    dismiss()
                    dismiss()
                }, label: {
                    Text("Done")
                        .fontWeight(.semibold)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(anxietyLevelType.color)
                        .foregroundColor(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 50))
                    
                })
            }.padding()
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

        .padding()
        .background(
            RadialGradient(colors: [
                Color(anxietyLevelType.color!), Color.backgroundSecondary],
                           center: .center, startRadius: 5, endRadius: 400)
        )
        
    }
}

//#Preview {
//    CategoryView(bgRed: 140, bgGreen: 165, bgBlue: 223)
//}
