import SwiftUI

struct HistoryNotesView: View {
    @EnvironmentObject var vm: NotesViewModel
    @State private var searchText = ""
    @State private var showEditView = false
    
    var groupedByDate: [String: [NoteEntity]] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let last7Days = calendar.date(byAdding: .day, value: -7, to: today)!
        let last30Days = calendar.date(byAdding: .day, value: -30, to: today)!
        
        return Dictionary(grouping: vm.notes) { noteEntity in
            let noteDate = calendar.startOfDay(for: noteEntity.timestamp!)
            if noteEntity.pinned {
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
                                        deleteNote(in: header, at: IndexSet(integer: notes.firstIndex(of: note)!))
                                    } label: {
                                        Label("Delete", systemImage: "trash")
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
                                deleteNote(in: header, at: indexSet)
                            }
                        }
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
                    EditButton()
                }

                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Spacer()
                        Button(action: {
                            createNewNote()
                        }) {
                            Image(systemName: "square.and.pencil")
                        }
                    }
                }
            }
            .navigationDestination(isPresented: $showEditView) {
                EditNotesView()
            }
        }
    }
    
    private func createNewNote() {
        Task {
            showEditView = true
        }
    }
    
    private func deleteNote(in header: String, at offsets: IndexSet) {
        if let notes = groupedByDate[header] {
            offsets.forEach { index in
                let noteToDelete = notes[index]
                
                if noteToDelete == vm.selectedNote {
                    vm.selectedNote = nil
                }
                
                Task {
                    await vm.deleteNote(noteToDelete)
                }
            }
        }
    }
    
    private func togglePin(for note: NoteEntity) {
        vm.togglePin(for: note)
    }
}
