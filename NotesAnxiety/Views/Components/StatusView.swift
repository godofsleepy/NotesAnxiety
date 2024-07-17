//
//  StatusView.swift
//  Notessss
//
//  Created by Sena Kristiawan on 17/07/24.
//

import SwiftUI

struct StatusView: View {
    var date: Date
    var anxietyImage : String
    var anxietyLabel: String
    var anxietyCategory: [String]
    var anxietyColor: Color
    @EnvironmentObject var vm: NotesViewModel
    var bgColor: Color
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(red: 99 / 255, green: 124 / 255, blue: 192 / 255).opacity(0.15).opacity(0.15))
                .frame(height: 90)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(red: 99 / 255, green: 124 / 255, blue: 192 / 255).opacity(0.5), lineWidth: 2))
            
            HStack(alignment: .top){
                    Image(systemName: anxietyImage)
                        .font(.system(size: 34))
                        .foregroundColor(anxietyColor)
                    
                    VStack(alignment: .leading) {
                        
                        HStack {
                            Text(formattedDate)
                                .font(.system(size: 14))
                                .foregroundColor(anxietyColor)
                            Spacer()
                            Button(action: {
                                self.vm.temporaryAnxiety = nil
                            }, label: {Image(systemName: "x.circle")})
                            .foregroundStyle(anxietyColor)
                        }
                        
                        Text(anxietyLabel)
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(anxietyColor)
                        
                        HStack {
                            ForEach(anxietyCategory, id: \.self) { category in
                                StatusComponent(anxietyCategory: category, anxietyColor: anxietyColor)
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
        return dateFormatter.string(from: date)
    }
}

#Preview {
    StatusView(date: Date(), anxietyImage: "cloud.drizzle.circle.fill", anxietyLabel: "Mild Anxiety", anxietyCategory: ["Family", "Test"], anxietyColor: Color.systemMinimal, bgColor: Color.cardsMinimal)
}
