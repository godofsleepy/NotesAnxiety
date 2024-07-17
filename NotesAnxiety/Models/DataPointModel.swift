//
//  DataPointModel.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 15/07/24.
//

import Foundation

struct DataPointModel: Identifiable {
    let id = UUID()
    let value: Double
    let label: String
}
