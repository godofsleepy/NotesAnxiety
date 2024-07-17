//
//  AnxietyLevelType.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 17/07/24.
//

import Foundation

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
}

extension AnxietyLevelType {
    static func from(average: Double) -> AnxietyLevelType {
        switch average {
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
