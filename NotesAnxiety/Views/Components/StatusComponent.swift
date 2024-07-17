//
//  StatusComponent.swift
//  Notessss
//
//  Created by Sena Kristiawan on 17/07/24.
//

import SwiftUI

struct StatusComponent: View {
    var anxietyCategory: String
    var anxietyColor: Color
    var body: some View {
        Text(anxietyCategory)
            .foregroundStyle(Color.backgroundPrimary)
            .padding(EdgeInsets(top: 4, leading: 14, bottom: 4, trailing: 14))
            .fontWeight(.medium)
            .background(
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(anxietyColor)
            .font(.system(size: 12))
            )
    }
}

#Preview {
    StatusComponent(anxietyCategory: "Family", anxietyColor: Color.systemMinimal)
}
