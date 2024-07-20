//
//  NotesViewModel.swift
//  Anxiety Notes
//
//  Created by Filbert Chai on 10/07/24.
//

import Foundation
import SwiftUI
import Combine

class NotesViewModel: ObservableObject {

    let localDataService : LocalDataService
    
    @Published var notes: [NoteModel] = []
    @Published var selectedNote: NoteModel?
    @Published var preferredColumn = NavigationSplitViewColumn.detail

    private var cancellables = Set<AnyCancellable>()
    private var noteUpdateSubject = PassthroughSubject<TemporaryNoteModel, Never>()
    

    init(localDataService: LocalDataService) {
        self.localDataService = localDataService
        noteUpdateSubject
            .debounce(for: .milliseconds(200), scheduler: DispatchQueue.main)
            .sink { [weak self] noteUpdate in
                guard let self = self else { return }
                Task {
                    await self.updateNote(noteUpdate)
                }
            }
            .store(in: &cancellables)
    }

    func togglePin(for note: NoteModel) {
        Task {
            var newNote = note
            newNote.pinned.toggle()
            do {
                try await localDataService.updateNote(newNote)
            } catch {
                print("\(error)")
            }
            await fetchNotes()
        }
    }

    func performUpdate(_ temporary: TemporaryNoteModel) {
        noteUpdateSubject.send(temporary)
    }
    
    func updateNote(_ temporary: TemporaryNoteModel) async {
        do {
            var updatedNote: NoteModel
            
            if selectedNote != nil{
                updatedNote = selectedNote!
            } else {
                updatedNote = try await localDataService.createNote()
            }
            
            updatedNote.title = temporary.title ?? updatedNote.title
            updatedNote.content = temporary.content ?? updatedNote.content
            updatedNote.anxiety = temporary.anxiety ?? updatedNote.anxiety
            
            selectedNote = updatedNote
            try await localDataService.updateNote(updatedNote)
        } catch {
            print("Error updating note: \(error.localizedDescription)")
        }
        
        await fetchNotes()
    }
    
    func fetchNotes(with searchText: String = "") async  {
        do {
            let data = try await localDataService.getNotes(searchText: searchText)
            DispatchQueue.main.async {
                self.notes = data
            }
        } catch {
            print("Error fetching notes: \(error)")
        }
    }

    func deleteNote(_ note: NoteModel) async {
        if selectedNote?.id == note.id {
            self.selectedNote = nil
        }
        do {
            try await localDataService.deleteNote(note)
        } catch {
            print("\(error.localizedDescription)")
        }
        Task {
            await fetchNotes()
        }
    }

    func searchNotes(with searchText: String) {
        Task {
           await fetchNotes(with: searchText)
        }
    }
}
