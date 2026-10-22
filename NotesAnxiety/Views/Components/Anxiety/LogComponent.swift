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
        CloudScene(anxietyLevelType: anxietyLevelType)
            .padding(.bottom)
            .frame(width: UIScreen.main.bounds.width, height: .infinity)
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
