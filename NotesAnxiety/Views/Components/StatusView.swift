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
    @State private var bgRed : Double = 140
    @State private var bgGreen : Double = 165
    @State private var bgBlue : Double = 223
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
                        .foregroundColor(Color(red: bgRed / 255, green: bgGreen / 255, blue: bgBlue / 255))
                    
                    VStack(alignment: .leading) {
                        Text(formattedDate)
                            .font(.system(size: 14))
                            .foregroundColor(Color(red: bgRed / 255, green: bgGreen / 255, blue: bgBlue / 255))
                        
                        Text(anxietyLabel)
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(Color(red: bgRed / 255, green: bgGreen / 255, blue: bgBlue / 255))
                        
                        HStack {
                            ForEach(anxietyCategory, id: \.self) { category in
                                StatusComponent(anxietyCategory: category, bgRed: self.bgRed, bgGreen: self.bgGreen, bgBlue: self.bgBlue)
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
    StatusView(date: Date(), anxietyImage: "cloud.drizzle.circle.fill", anxietyLabel: "Mild Anxiety", anxietyCategory: ["Family", "Test"], bgColor: Color(red: 99/255, green: 124/255, blue: 192/255))
}
