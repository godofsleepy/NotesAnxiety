//
//  LogComponent.swift
//  Notessss
//
//  Created by Sena Kristiawan on 17/07/24.
//

import SwiftUI

enum AnxietyState{
    case minimal
    case mild
    case moderate
    case severe
}

struct LogComponent: View {
    var label: String
    var state: AnxietyState
    var body: some View {
        Image(systemName: imageName(for: state))
            .font(.system(size: 100))
            .padding(.bottom)
            .foregroundColor(Color.white)
            .animation(Animation.linear, value: state)
            .frame(width: 100, height: 100)
        HStack{
            Text(label)
                .foregroundStyle(Color.white)
                .fontWeight(.bold)
                .font(.system(size: 32))
            Text("Anxiety")
                .foregroundStyle(Color.white)
                .fontWeight(.medium)
                .font(.system(size: 32))
        
        }
    }
    private func imageName(for condition: AnxietyState) -> String {
            switch condition {
            case .minimal:
                return "cloud.fill"
            case .mild:
                return "cloud.rain.fill"
            case .moderate:
                return "cloud.heavyrain.fill"
            case .severe:
                return "cloud.bolt.rain.fill"
            }
        }
}

#Preview {
    LogComponent(label: "Minimal", state: .minimal)
}
