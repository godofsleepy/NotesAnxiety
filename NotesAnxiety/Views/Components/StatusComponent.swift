//
//  StatusComponent.swift
//  Notessss
//
//  Created by Sena Kristiawan on 17/07/24.
//

import SwiftUI

struct StatusComponent: View {
    var anxietyCategory: String
    @State var bgRed : Double
    @State var bgGreen : Double
    @State var bgBlue : Double
    var body: some View {
        Text(anxietyCategory)
            .foregroundStyle(Color.white)
            .padding(EdgeInsets(top: 4, leading: 14, bottom: 4, trailing: 14))
            .fontWeight(.medium)
            .background(
                RoundedRectangle(cornerRadius: 25.0)
                    .foregroundColor(Color(red: bgRed/255, green: bgGreen/255, blue: bgBlue/255)))
            .font(.system(size: 12))
    }
}

#Preview {
    StatusComponent(anxietyCategory: "Family", bgRed: 99, bgGreen: 124, bgBlue: 192)
}
