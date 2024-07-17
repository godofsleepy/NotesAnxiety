//
//  AnxietyCategory.swift
//  NotesAnxiety
//
//  Created by Sena Kristiawan on 16/07/24.
//

import SwiftUI

struct AnxietyCategoryView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        VStack{
            HStack{
                Text("What do you think trigger this feeling?")
                    .fontWeight(.bold)
                    .font(.system(size: 24))
                Spacer()
                Button(action: {
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.gray)
                }
            }
            HStack{
                AnxietyCategoryComponent(label: "Health")
                AnxietyCategoryComponent(label: "Fitness")
                AnxietyCategoryComponent(label: "Self-Care")
                AnxietyCategoryComponent(label: "Hobbies")
                AnxietyCategoryComponent(label: "Identity")
                AnxietyCategoryComponent(label: "Spirituality")
                AnxietyCategoryComponent(label: "Community")
                AnxietyCategoryComponent(label: "Family")
                AnxietyCategoryComponent(label: "Friend")
                AnxietyCategoryComponent(label: "Partner")
                AnxietyCategoryComponent(label: "Dating")
                AnxietyCategoryComponent(label: "Task")
                AnxietyCategoryComponent(label: "Work")
                AnxietyCategoryComponent(label: "Education")
                AnxietyCategoryComponent(label: "Travel")
                AnxietyCategoryComponent(label: "Weather")
                AnxietyCategoryComponent(label: "Current")
                AnxietyCategoryComponent(label: "Event")
                AnxietyCategoryComponent(label: "Money")
                
                Button(action: {}){
                    RoundedRectangle(cornerRadius: 10)
                    .foregroundStyle(.blue)
                    .frame(width: 81, height: 32)
                    
                    Text("Submit")
                        .foregroundStyle(.white)
                        .padding()
                        .font(.system(size: 12))
                }
                
            }
        }
        .frame(width: .infinity, height: 200)
        
    }
}

#Preview {
    AnxietyCategoryView()
}
