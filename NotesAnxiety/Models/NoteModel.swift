//
//  NoteModel.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 20/07/24.
//

import Foundation

struct NoteModel: Identifiable {
    let id: UUID
    var title: String?
    var content: String?
    var anxiety: AnxietyModel?
    var pinned: Bool = false
    let createdAt: Date
}

extension NoteModel {
    static func fromNoteEntity(_ note: NoteEntity) -> NoteModel {
        NoteModel(
            id: note.id!,
            title: note.title,
            content: note.content,
            anxiety: note.anxietyLevel >= 1 ? AnxietyModel(
                value: note.anxietyLevel,
                categoryAnxiety: note.categoryAnxiety == nil ? [] : note.categoryAnxiety!.split(separator: ",").map(String.init),
                createdAt: Date()
            ) : nil,
            pinned: note.pinned,
            createdAt: note.timestamp!
        )
    }
}

struct AnxietyModel: Equatable {
    let value: Double
    let type: AnxietyLevelType
    let categoryAnxiety: [String]
    let createdAt: Date
    
    init(value: Double, categoryAnxiety: [String], createdAt: Date) {
        self.value = value
        self.type = AnxietyLevelType.from(value)
        self.categoryAnxiety = categoryAnxiety
        self.createdAt = createdAt
    }

    // Custom implementation of == operator
    static func ==(lhs: AnxietyModel, rhs: AnxietyModel) -> Bool {
        return lhs.value == rhs.value &&
               lhs.type == rhs.type &&
               lhs.categoryAnxiety == rhs.categoryAnxiety &&
               lhs.createdAt == rhs.createdAt
    }
}
