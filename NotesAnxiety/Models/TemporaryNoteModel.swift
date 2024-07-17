//
//  TemporaryNoteModel.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 14/07/24.
//

import Foundation

struct TemporaryNoteModel {
    var title: String = ""
    var content: String = ""
    var photoPath: String?
    var videoPath: String?
    var audiotPath: String?
    var anxietyLevel: Double = 0
    var categoryAnxiety: [String] = []
    var pinned: Bool = false
}
