//
//  StatusView.swift
//  Notessss
//
//  Created by Sena Kristiawan on 17/07/24.
//

import SwiftUI

struct StatusView: View {
    var anxiety: AnxietyTemporaryModel
    var onDelete: () -> Void

    private var type: AnxietyLevelType {
        AnxietyLevelType.from(anxiety.anxietyLevel)
    }

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 20)
                .foregroundColor(Color(red: 99 / 255, green: 124 / 255, blue: 192 / 255).opacity(0.15).opacity(0.15))
                .frame(height: 90)
                .overlay(
                    RoundedRectangle(cornerRadius: 20)
                        .stroke(Color(red: 99 / 255, green: 124 / 255, blue: 192 / 255).opacity(0.5), lineWidth: 2))

            HStack(alignment: .top){
                Image(systemName: type.icon ?? "cloud.fill")
                        .font(.system(size: 34))
                        .foregroundColor(type.color)

                    VStack(alignment: .leading) {

                        HStack {
                            Text(formattedDate)
                                .font(.system(size: 14))
                                .foregroundColor(type.color)
                            Spacer()
                            Button(action: onDelete, label: {Image(systemName: "x.circle")})
                            .foregroundStyle(type.color ?? .white)
                        }

                        Text(type.rawValue)
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                            .foregroundColor(type.color)

                        ScrollView(.horizontal,showsIndicators: false) {
                            HStack {
                                ForEach(anxiety.categoryAnxiety, id: \.self) { category in
                                    StatusComponent(anxietyCategory: category, anxietyColor: type.color ?? .white)
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
