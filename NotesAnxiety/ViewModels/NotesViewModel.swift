//
//  NotesViewModel.swift
//  Anxiety Notes
//
//  Created by Filbert Chai on 10/07/24.
//

import Foundation
import SwiftUI
import Observation

@Observable
@MainActor
final class NotesViewModel {

    let localDataService: LocalDataService
    var notes: [NoteEntity] = []
    var selectedNote: NoteEntity? {
        didSet { updateProgressState = .Default }
    }
    var isDataLoaded = false
    var preferredColumn = NavigationSplitViewColumn.detail
    var updateProgressState = ProgressState.Default
    var temporaryAnxiety: AnxietyTemporaryModel?

    @ObservationIgnored private var searchText = ""
    @ObservationIgnored private var pendingUpdate: Task<Void, Never>?
    @ObservationIgnored private var pendingTarget: NoteEntity?

    init(localDataService: LocalDataService) {
        self.localDataService = localDataService
    }

    func togglePin(for note: NoteEntity) {
        localDataService.togglePin(for: note)
        fetchNotes()
    }

    /// Autosave entry point. Rapid edits are coalesced: only the last change
    /// within one second is written.
    func performUpdate(title: String, content: String, audioPath: String?, videoPath: String?, photoPath: String?, pinned: Bool?, anxiety: AnxietyTemporaryModel?) {
        if let note = selectedNote,
           title == note.title, content == note.content,
           audioPath == note.audioPath, videoPath == note.videoPath, photoPath == note.photoPath,
           (pinned ?? note.pinned) == note.pinned,
           (anxiety?.anxietyLevel ?? 0) == note.anxietyLevel,
           (anxiety?.categoryAnxiety ?? []) == note.categories {
            return
        }
        updateProgressState = .Loading
        let noteUpdate = TemporaryNoteModel(
            title: title,
            content: content,
            photoPath: photoPath,
            videoPath: videoPath,
            audiotPath: audioPath,
            anxietyLevel: anxiety?.anxietyLevel ?? 0,
            categoryAnxiety: anxiety?.categoryAnxiety ?? [],
            pinned: pinned ?? selectedNote?.pinned ?? false
        )
        // Capture the target now so switching notes during the delay can't
        // redirect this edit to a different note.
        // A pending edit for another note is left to finish.
        let target = selectedNote
        if pendingTarget === target {
            pendingUpdate?.cancel()
        }
        pendingTarget = target
        pendingUpdate = Task {
            try? await Task.sleep(for: .seconds(1))
            guard !Task.isCancelled else { return }
            updateNote(target, with: noteUpdate)
        }
    }

    private func updateNote(_ target: NoteEntity?, with temporaryNote: TemporaryNoteModel) {
        let note: NoteEntity
        if let target {
            guard !target.isDeleted, target.modelContext != nil else { return }
            note = target
        } else {
            // Select the new note so later edits update it instead of
            // creating another one.
            note = localDataService.createNote()
            selectedNote = note
        }
        localDataService.updateNote(note, temporaryNote: temporaryNote)
        updateProgressState = .Complete
        fetchNotes()
    }

    func fetchNotes() {
        do {
            notes = try localDataService.fetchNotes(searchText: searchText)
            isDataLoaded = true
        } catch {
            print("Error fetching notes: \(error)")
        }
    }

    func deleteNote(_ note: NoteEntity) {
        if pendingTarget === note {
            pendingUpdate?.cancel()
        }
        if selectedNote == note {
            selectedNote = nil
        }
        localDataService.deleteNote(note)
        fetchNotes()
    }

    func searchNotes(with searchText: String) {
        self.searchText = searchText
        fetchNotes()
    }
}
