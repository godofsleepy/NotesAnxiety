//
//  LogComponent.swift
//  Notessss
//
//  Created by Sena Kristiawan on 17/07/24.
//

import SwiftUI

struct LogComponent: View {
    var anxietyLevelType: AnxietyLevelType
    
    var body: some View {
        Image(systemName: anxietyLevelType.icon!)
            .font(.system(size: 100))
            .padding(.bottom)
            .foregroundColor(Color.white)
            .animation(Animation.linear, value: anxietyLevelType)
            .frame(width: 100, height: 100)
        HStack{
            Text(anxietyLevelType.rawValue)
                .foregroundStyle(Color.white)
                .fontWeight(.bold)
                .font(.system(size: 32))

        }
    }
  
}

//#Preview {
//    LogComponent(label: "Minimal", state: .minimal)
//}
