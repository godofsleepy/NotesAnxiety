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
    @Published var notes: [NoteEntity] = []
    @Published var selectedNote: NoteEntity? 
    @Published var isDataLoaded = false
    @Published var preferredColumn = NavigationSplitViewColumn.detail
    @Published var updateProgressState = ProgressState.Default
    private var updateNotesCancellable: AnyCancellable?
    private var noteUpdateSubject = PassthroughSubject<TemporaryNoteModel, Never>()
    

    init(localDataService: LocalDataService) {
        self.localDataService = localDataService
        updateNotesCancellable = noteUpdateSubject
            .debounce(for: .milliseconds(1000), scheduler: DispatchQueue.main)
            .removeDuplicates { $0.title == $1.title && $0.content == $1.content }
            .sink { [weak self] noteUpdate in
                guard let self = self else { return }
                Task {
                    await self.updateNote(title: noteUpdate.title, content: noteUpdate.content)
                }
            }
    }
    
    func performUpdate(title: String, content: String) {
        if title == selectedNote?.title && content == selectedNote?.content {
            return
        }
        updateProgressState = ProgressState.Loading
        let noteUpdate = TemporaryNoteModel(title: title, content: content)
        noteUpdateSubject.send(noteUpdate)
    }
    
    func updateNote(title: String, content: String) async {
        let note = if selectedNote == nil {
            await createNote()
        } else {
            selectedNote
        }
        DispatchQueue.main.async {
            self.selectedNote = note
        }
        await localDataService.updateNote(note!, title: title, content: content)
        DispatchQueue.main.async {
            self.updateProgressState = ProgressState.Complete
        }
        await fetchNotes()
    }
       
    func fetchNotes(with searchText: String = "") async  {
        do {
            let data = try await localDataService.fetchNotes(searchText: searchText)
            DispatchQueue.main.async {
                self.isDataLoaded = true
                self.notes = data
            }
        } catch {
            print("Error fetching notes: \(error)")
        }
    }

    func createNote() async -> NoteEntity {
        let newNote = await localDataService.createNote()
        Task {
            await fetchNotes()
        }
        return newNote
    }

    func deleteNote(_ note: NoteEntity) async {
        await localDataService.deleteNote(note)
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

