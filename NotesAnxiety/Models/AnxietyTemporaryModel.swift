//
//  AnxietyTemporaryModel.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 18/07/24.
//

import Foundation
import SwiftUI

struct AnxietyTemporaryModel: Equatable {
    let anxietyLevel: Double
    let categoryAnxiety: [String]
    var createdAt = Date()
    let anxietyColor: Color
}
