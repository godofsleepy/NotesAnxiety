//
//  NotesViewModel.swift
//  Anxiety Notes
//
//  Created by Filbert Chai on 10/07/24.
//

import Foundation
import CoreData

class NotesViewModel: ObservableObject {

    let localDataService : LocalDataService
    @Published var notes: [NoteEntity] = []
    @Published var isDataLoaded = false

    init(localDataService: LocalDataService) {
        self.localDataService = localDataService
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

    func updateNote(_ note: NoteEntity, title: String, content: String) async {
        await localDataService.updateNote(note, title: title, content: content)
        await fetchNotes()
    }
    
    func searchNotes(with searchText: String) {
        Task {
           await fetchNotes(with: searchText)
        }
    }
}

