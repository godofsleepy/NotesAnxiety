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
    @Binding var anxietyLevel: Double
    @State var valueCategory: [String] = []
    
    var bgRed: Double
    var bgGreen: Double
    var bgBlue: Double

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
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 40, trailing: 0))
                Button(action: {
                    vm.temporaryAnxiety = AnxietyTemporaryModel(anxietyLevel: anxietyLevel, categoryAnxiety: valueCategory)
                    dismiss()
                    dismiss()
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

//#Preview {
//    CategoryView(bgRed: 140, bgGreen: 165, bgBlue: 223)
//}
