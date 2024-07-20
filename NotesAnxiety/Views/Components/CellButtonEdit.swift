//
//  CellButtonEdit.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 16/07/24.
//

import SwiftUI

struct CellButtonEdit: View {
    @EnvironmentObject var vm: NotesViewModel
    
    var note: NoteModel
    
    var body: some View {
        Button {
            vm.togglePin(for: note)
        } label: {
            Label(note.pinned ? "Unpin" : "Pin", systemImage: note.pinned ? "pin.slash" : "pin")
        }
        .tint(note.pinned ? .gray : .orange)
    }
}

//#Preview {
//    CellButtonEdit()
//}
