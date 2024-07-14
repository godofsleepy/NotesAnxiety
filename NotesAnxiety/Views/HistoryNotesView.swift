//
//  HistoryNotesView.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 14/07/24.
//

import SwiftUI

struct HistoryNotesView: View {
    @EnvironmentObject var vm: NotesViewModel
    @State var showConfirmationDialogue: Bool = false
    @State var showOverlay: Bool = false
    @State private var searchText = ""
    
    @State private var selectedNote: NoteEntity?
    
    var groupedByDate: [Date: [NoteEntity]] {
        let calendar = Calendar.current
        return Dictionary(grouping: vm.notes) { noteEntity in
            let dateComponents = calendar.dateComponents([.year, .month, .day], from: noteEntity.timestamp!)
            return calendar.date(from: dateComponents) ?? Date()
        }
    }
    
    var headers: [Date] {
        groupedByDate.map { $0.key }.sorted(by: { $0 > $1 })
    }
    
    var body: some View {
        List(selection: $selectedNote) {
            ForEach(headers, id: \.self) { header in
                Section(header: Text(header, style: .date)) {
                    ForEach(groupedByDate[header]!) { note in
                        HStack{
                            ListCellView(note: note)
                            Spacer()
                        }
                        .contentShape(Rectangle())
                        .onTapGesture {
                            vm.selectedNote = note
                            vm.preferredColumn = NavigationSplitViewColumn.detail
                        }
                        
                    }
                    .onDelete(perform: { indexSet in
                        deleteNote(in: header, at: indexSet)
                    })
                }
            }
        }
        .id(UUID())
        .navigationTitle("History")
        .searchable(text: $searchText)
        .onChange(of: searchText) {
            vm.searchNotes(with: searchText)
        }
        .toolbar {
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    vm.preferredColumn = NavigationSplitViewColumn.detail
                }) {
                    Image(systemName: "sidebar.leading")
                }
            }

            ToolbarItem(placement: .navigationBarTrailing) {
                Button {
                    
                } label: {
                    Text("Edit")
                }
            }
        }
    }
    
    private func createNewNote() {
        Task {
            selectedNote = nil
            selectedNote = await vm.createNote()
        }
    }
    
    private func deleteNote(in header: Date, at offsets: IndexSet) {
        offsets.forEach { index in
            if let noteToDelete = groupedByDate[header]?[index] {
                
                if noteToDelete == selectedNote {
                    selectedNote = nil
                }
                
                Task {
                    await vm.deleteNote(noteToDelete)
                }
            }
        }
    }
    
}

#Preview {
    HistoryNotesView()
}
