//
//  StatusView.swift
//  Notessss
//
//  Created by Sena Kristiawan on 17/07/24.
//

import SwiftUI

struct StatusView: View {
    @EnvironmentObject var vm: NotesViewModel
    
    var anxiety: AnxietyModel
    var onDelete: () -> Void
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(red: 99 / 255, green: 124 / 255, blue: 192 / 255).opacity(0.15).opacity(0.15))
                .frame(height: 90)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(red: 99 / 255, green: 124 / 255, blue: 192 / 255).opacity(0.5), lineWidth: 2))
            
            HStack(alignment: .top){
                Image(systemName: anxiety.type.icon!)
                        .font(.system(size: 34))
                        .foregroundColor(anxiety.type.color)
                    
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Text(formattedDate)
                                .font(.system(size: 14))
                                .foregroundColor(anxiety.type.color)
                            Spacer()
                            Button(action: onDelete, label: {Image(systemName: "x.circle")})
                            .foregroundStyle(anxiety.type.color!)
                        }
                        
                        Text(anxiety.type.rawValue)
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(anxiety.type.color)
                        
                        ScrollView(.horizontal,showsIndicators: false) {
                            HStack {
                                ForEach(anxiety.categoryAnxiety, id: \.self) { category in
                                    StatusComponent(anxietyCategory: category, anxietyColor: anxiety.type.color!)
                                }
                            }

                        }                       
                        .padding(.top, -10)
                    }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
    
    private var formattedDate: String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE, dd MMMM yyyy"
        return dateFormatter.string(from: anxiety.createdAt)
    }
}

//#Preview {
//    StatusView(date: Date(), anxietyImage: "cloud.drizzle.circle.fill", anxietyLabel: "Mild Anxiety", anxietyCategory: ["Family", "Test"], anxietyColor: Color.systemMinimal, bgColor: Color.cardsMinimal)
//}
