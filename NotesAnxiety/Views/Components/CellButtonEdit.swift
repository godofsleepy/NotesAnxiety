//
//  CellButtonEdit.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 16/07/24.
//

import SwiftUI

struct CellButtonEdit: View {
    @Environment(NotesViewModel.self) private var vm
    
    var note: NoteEntity
    
    var body: some View {
        Button {
            vm.performUpdate(
                title: note.title ?? "",
                content: note.content ?? "",
                audioPath: note.audioPath,
                videoPath: note.videoPath,
                photoPath: note.photoPath,
                pinned: !note.pinned,
                anxiety: AnxietyTemporaryModel(anxietyLevel: note.anxietyLevel, categoryAnxiety: note.categories, anxietyColor: AnxietyLevelType.color(anxiety: note.anxietyLevel))
            )
        } label: {
            Label(note.pinned ? "Unpin" : "Pin", systemImage: note.pinned ? "pin.slash" : "pin")
        }
        .tint(note.pinned ? .gray : .orange)
    }
}

//#Preview {
//    CellButtonEdit()
//}
