//
//  LocalDataService.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 10/07/24.
//

import Foundation
import CoreData

protocol LocalDataService {
    func fetchNotes(searchText: String) async throws -> [NoteEntity]
    func createNote() async -> NoteEntity
    func updateNote(_ note: NoteEntity, temporaryNote: TemporaryNoteModel) async -> NoteEntity
    func togglePin(for note: NoteEntity) async
    func deleteNote(_ note: NoteEntity) async
}

class LocalDataServiceImpl : LocalDataService {
        
    let notesContainer: NSPersistentContainer
    
    init() {
        notesContainer = NSPersistentContainer(name: "NotesContainer")
        notesContainer.loadPersistentStores { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        }
    }
    
    func togglePin(for note: NoteEntity) async {
        notesContainer.viewContext.performAndWait {
            note.pinned.toggle()
            saveContext()
        }
    }

    
    func createNote() async -> NoteEntity {
        notesContainer.viewContext.performAndWait {
            let newNote = NoteEntity(context: notesContainer.viewContext)
            newNote.id = UUID()
            newNote.timestamp = Date()
            saveContext()
            
            return newNote
        }
    }
    
    func updateNote(_ note: NoteEntity, temporaryNote: TemporaryNoteModel) async -> NoteEntity {
        return notesContainer.viewContext.performAndWait {
            note.title = temporaryNote.title
            note.content = temporaryNote.content
            note.audioPath = temporaryNote.audiotPath
            note.photoPath = temporaryNote.photoPath
            note.videoPath = temporaryNote.videoPath
            note.pinned = temporaryNote.pinned
            note.anxietyLevel = temporaryNote.anxietyLevel
            note.categoryAnxiety = temporaryNote.categoryAnxiety.joined(separator: ",")
            saveContext()
            return note
        }
    }
    
    func deleteNote(_ note: NoteEntity) async {
        notesContainer.viewContext.performAndWait {
            notesContainer.viewContext.delete(note)
            saveContext()
        }
    }
    

    func fetchNotes(searchText: String) async throws -> [NoteEntity] {
       try notesContainer.viewContext.performAndWait {
            let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            
            if !searchText.isEmpty {
                request.predicate = NSPredicate(format: "title CONTAINS %@", searchText)
            }
            
            return try notesContainer.viewContext.fetch(request)
        }
    }
    
    private func saveContext() {
        do {
            try notesContainer.viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
