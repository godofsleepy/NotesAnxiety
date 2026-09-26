//
//  LocalDataService.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 10/07/24.
//

import Foundation
import SwiftData
import WidgetKit

@MainActor
protocol LocalDataService {
    func fetchNotes(searchText: String) throws -> [NoteEntity]
    func createNote() -> NoteEntity
    func updateNote(_ note: NoteEntity, temporaryNote: TemporaryNoteModel)
    func togglePin(for note: NoteEntity)
    func deleteNote(_ note: NoteEntity)
}

@MainActor
final class LocalDataServiceImpl: LocalDataService {

    private let context: ModelContext

    init(container: ModelContainer) {
        context = container.mainContext
    }

    func togglePin(for note: NoteEntity) {
        note.pinned.toggle()
        saveContext()
    }

    func createNote() -> NoteEntity {
        let newNote = NoteEntity()
        context.insert(newNote)
        saveContext()
        return newNote
    }

    func updateNote(_ note: NoteEntity, temporaryNote: TemporaryNoteModel) {
        note.title = temporaryNote.title
        note.content = temporaryNote.content
        note.audioPath = temporaryNote.audiotPath
        note.photoPath = temporaryNote.photoPath
        note.videoPath = temporaryNote.videoPath
        note.pinned = temporaryNote.pinned
        note.anxietyLevel = temporaryNote.anxietyLevel
        note.categories = temporaryNote.categoryAnxiety
        saveContext()
    }

    func deleteNote(_ note: NoteEntity) {
        context.delete(note)
        saveContext()
    }

    func fetchNotes(searchText: String) throws -> [NoteEntity] {
        let descriptor = FetchDescriptor<NoteEntity>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)])
        let notes = try context.fetch(descriptor)
        guard !searchText.isEmpty else { return notes }
        return notes.filter { $0.title?.localizedCaseInsensitiveContains(searchText) == true }
    }

    private func saveContext() {
        do {
            try context.save()
            WidgetCenter.shared.reloadAllTimelines()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
