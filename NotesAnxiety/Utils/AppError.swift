//
//  AppError.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 11/07/24.
//

import Foundation

enum AppError: LocalizedError {
    case databaseError
    case fileNotFound
    case invalidInput
    
    var errorDescription: String? {
        switch self {
        case .databaseError:
            return NSLocalizedString("NetworkError", comment: "Network error occurred")
        case .fileNotFound:
            return NSLocalizedString("FileNotFound", comment: "The requested file was not found")
        case .invalidInput:
            return NSLocalizedString("InvalidInput", comment: "The input provided is invalid")
        }
    }
}
