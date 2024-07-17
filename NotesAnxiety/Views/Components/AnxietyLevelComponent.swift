//
//  AnxietyLevelComponent.swift
//  NotesAnxiety
//
//  Created by Sena Kristiawan on 16/07/24.
//

import SwiftUI

struct AnxietyLevelComponent: View {
    @State public var imageName: String
    public var color: Color
    public var text: String
    
    init(image: String, text: String, color: Color) {
            self._imageName = State(initialValue: image)
            self.text = text
            self.color = color
        }
    
    var body: some View {
            
        VStack{
            Image(systemName: imageName)
                .font(.system(size: 40))
                .foregroundStyle(color)
            Text(text)
                .font(Font.system(size: 12))
                .foregroundStyle(Color.white)
        }
        .padding()
    }
}

#Preview {
    AnxietyLevelComponent(image: "cloud.circle", text: "Sample Text", color: .black)
}
