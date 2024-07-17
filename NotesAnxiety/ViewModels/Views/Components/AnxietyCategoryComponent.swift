//
//  AnxietyCategoryComponent.swift
//  NotesAnxiety
//
//  Created by Sena Kristiawan on 16/07/24.
//

import SwiftUI

struct AnxietyCategoryComponent: View {
    public var label: String
    var body: some View {
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/){
            RoundedRectangle(cornerRadius: 10)
                .foregroundColor(.white)
                .border(Color.gray)
                Text(label)
                    .padding()
                    .font(.system(size: 12))
        }
        .foregroundColor(.gray)
    }
}

#Preview {
    AnxietyCategoryComponent(label: "test")
}
