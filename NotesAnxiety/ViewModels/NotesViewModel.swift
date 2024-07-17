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
    private var cancellables = Set<AnyCancellable>()
    private var noteUpdateSubject = PassthroughSubject<TemporaryNoteModel, Never>()

    init(localDataService: LocalDataService) {
        self.localDataService = localDataService
        noteUpdateSubject
            .debounce(for: .milliseconds(1000), scheduler: DispatchQueue.main)
            .removeDuplicates { $0.title == $1.title && $0.content == $1.content }
            .sink { [weak self] noteUpdate in
                guard let self = self else { return }
                Task {
                    await self.updateNote(noteUpdate)
                }
            }
            .store(in: &cancellables)
        $selectedNote.sink(receiveValue: { note in
            DispatchQueue.main.async {
                self.updateProgressState = ProgressState.Default
            }
        }).store(in: &cancellables)
    }

    func togglePin(for note: NoteEntity) {
        Task {
            await localDataService.togglePin(for: note)
            await fetchNotes() // Ensure the notes array is updated after pinning/unpinning
        }
    }

    func performUpdate(title: String, content: String, audioPath: String?, videoPath: String?, photoPath: String?, pinned: Bool) {
        if title == selectedNote?.title && content == selectedNote?.content, audioPath == selectedNote?.audioPath && videoPath == selectedNote?.videoPath && photoPath == selectedNote?.photoPath && pinned == selectedNote?.pinned {
            return
        }
        updateProgressState = ProgressState.Loading
        let noteUpdate = TemporaryNoteModel(
            title: title,
            content: content,
            photoPath: photoPath,
            videoPath: videoPath,
            audiotPath: audioPath,
            pinned: pinned
        )
        noteUpdateSubject.send(noteUpdate)
    }

    func updateNote(_ temporaryNote: TemporaryNoteModel) async {
        let note = if selectedNote == nil {
            await createNote()
        } else {
            selectedNote
        }
        DispatchQueue.main.async {
            self.selectedNote = note
        }
        await localDataService.updateNote(note!, temporaryNote: temporaryNote)
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
        if selectedNote == note {
            self.selectedNote = nil
            self.updateProgressState = ProgressState.Default
        }
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
