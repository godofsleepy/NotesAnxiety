import SwiftUI

struct HistoryNotesView: View {
    @EnvironmentObject var vm: NotesViewModel
    @State private var searchText = ""
    
    var groupedByDate: [String: [NoteModel]] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let last7Days = calendar.date(byAdding: .day, value: -7, to: today)!
        let last30Days = calendar.date(byAdding: .day, value: -30, to: today)!
        
        return Dictionary(grouping: vm.notes) { note in
            let noteDate = calendar.startOfDay(for: note.createdAt)
            if note.pinned {
                return "Pinned"
            } else if noteDate == today {
                return "Today"
            } else if noteDate >= last7Days {
                return "Last 7 Days"
            } else if noteDate >= last30Days {
                return "Last 30 Days"
            } else {
                return "Older"
            }
        }
    }
    
    var headers: [String] {
        ["Pinned", "Today", "Last 7 Days", "Last 30 Days", "Older"]
    }
    
    var body: some View {
        NavigationStack {
            List {
                ForEach(headers, id: \.self) { header in
                    if let notes = groupedByDate[header], !notes.isEmpty {
                        Section(header: Text(header)) {
                            ForEach(notes) { note in
                                HStack {
                                    ListCellView(note: note)
                                    Spacer()
                                }
                                .contentShape(Rectangle())
                                .onTapGesture {
                                    vm.selectedNote = note
                                    vm.preferredColumn = NavigationSplitViewColumn.detail
                                }
                                .swipeActions(edge: .trailing, allowsFullSwipe: true) {
                                    Button(role: .destructive) {
                                        deleteNote(note)
                                    } label: {
                                        Label(NSLocalizedString("Delete", comment: ""), systemImage: "trash")
                                    }
                                }
                                .swipeActions(edge: .leading, allowsFullSwipe: false) {
                                    Button {
                                        togglePin(for: note)
                                    } label: {
                                        Label(note.pinned ? "Unpin" : "Pin", systemImage: note.pinned ? "pin.slash" : "pin")
                                    }
                                    .tint(note.pinned ? .gray : .orange)
                                }
                            }
                            .onDelete { indexSet in
                                if let notes = groupedByDate[header], !notes.isEmpty {
                                    for index in indexSet {
                                           let note = notes[index]
                                           deleteNote(note)
                                       }
                                }
                            }
                        }
                    }
                }
            }
            .id(UUID())
            .navigationTitle(NSLocalizedString("History", comment: ""))
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
                    EditButton()
                }

                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Spacer()
                        Button(action: {
                            vm.preferredColumn = NavigationSplitViewColumn.detail
                        }) {
                            Image(systemName: "square.and.pencil")
                        }
                    }
                }
            }
    
        }
    }
    
    
    private func deleteNote(_ note: NoteModel) {
        if note.id == vm.selectedNote?.id {
            vm.selectedNote = nil
        }
        
        Task {
            await vm.deleteNote(note)
        }

    }
    
    private func togglePin(for note: NoteModel) {
        vm.togglePin(for: note)
    }
}
