//
//  LocalDataService.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 10/07/24.
//

import Foundation
import CoreData

protocol LocalDataService {
    func getNotes(searchText: String) async throws -> [NoteModel]
    func createNote() async throws -> NoteModel
    func updateNote(_ note: NoteModel) async throws -> NoteModel
    func deleteNote(_ note: NoteModel) async throws
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
    
    func getNotes(searchText: String) async throws -> [NoteModel] {
        try await notesContainer.viewContext.perform {
            let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
            request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
            
            if !searchText.isEmpty {
                request.predicate = NSPredicate(format: "title CONTAINS %@", searchText)
            }
            
            let result = try self.notesContainer.viewContext.fetch(request)
            return result.map {
                NoteModel.fromNoteEntity($0)
            }
        }
    }
    
    func createNote() async throws -> NoteModel {
        try await notesContainer.viewContext.perform {
            let newNote = NoteEntity(context: self.notesContainer.viewContext)
            newNote.id = UUID()
            newNote.timestamp = Date()
            try self.notesContainer.viewContext.save()
            
            return NoteModel.fromNoteEntity(newNote)
        }
    }
    
    func updateNote(_ note: NoteModel) async throws -> NoteModel {
        let result = try await getNoteById(uuid: note.id)
        return try await notesContainer.viewContext.perform {
            result.title = note.title
            result.content = note.content
            result.pinned = note.pinned
            result.anxietyLevel = note.anxiety?.value ?? 0
            result.categoryAnxiety = note.anxiety?.categoryAnxiety.joined(separator: ",") ?? ""
            
            try self.notesContainer.viewContext.save()
            return note
        }
    }
    
    func getNoteById(uuid: UUID) async throws -> NoteEntity {
        return try await notesContainer.viewContext.perform{
            let fetchRequest: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
            fetchRequest.predicate = NSPredicate(format: "id == %@", uuid as CVarArg)
            fetchRequest.fetchLimit = 1
            
            guard let result = try self.notesContainer.viewContext.fetch(fetchRequest).first else {
                throw AppError.databaseError
            }
            return result
        }
    }
    
    func deleteNote(_ note: NoteModel) async throws {
        let result = try await getNoteById(uuid: note.id)
        try await notesContainer.viewContext.perform {
            self.notesContainer.viewContext.delete(result)
            try self.notesContainer.viewContext.save()
        }
    }
    
}
