//
//  AnxietyLevelType.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 17/07/24.
//

import Foundation
import SwiftUI

enum AnxietyLevelType: String, Codable {
    case minimal = "Minimal"
    case mild = "Mild"
    case moderate = "Moderate"
    case severe = "Severe"
    case empty = "Empty"
    
    var numericalValue: Int {
        switch self {
        case .minimal:
            return 1
        case .mild:
            return 2
        case .moderate:
            return 3
        case .severe:
            return 4
        case .empty:
            return 0
        }
    }
    
    var icon: String? {
        switch self {
        case .minimal:
            
            return "cloud.fill"
        case .mild:
            return "cloud.rain.fill"
        case .moderate:
            return "cloud.heavyrain.fill"
        case .severe:
            return "cloud.bolt.rain.fill"
        case .empty:
            return nil
        }
    }
    
    var color: Color? {
        switch self {
        case .minimal:
            return Color("SystemMinimal")
        case .mild:
            return  Color("SystemMild")
        case .moderate:
            return Color("SystemModerate")
        case .severe:
            return Color("SystemSevere")
        case .empty:
            return nil
        }
    }
    
    
}

extension AnxietyLevelType {
    static func from(_ value: Double) -> AnxietyLevelType {
        switch value {
        case 0..<1.5:
            return .minimal
        case 1.5..<2.5:
            return .mild
        case 2.5..<3.5:
            return .moderate
        case 3.5...4:
            return .severe
        default:
            return .empty
        }
    }    
}
