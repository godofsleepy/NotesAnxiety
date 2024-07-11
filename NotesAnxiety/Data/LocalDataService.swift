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
    func updateNote(_ note: NoteEntity, title: String, content: String) async
    func deleteNote(_ note: NoteEntity) async
}

class LocalDataServiceImpl : LocalDataService, ObservableObject {
    let notesContainer: NSPersistentContainer
    
    init() {
        notesContainer = NSPersistentContainer(name: "NotesContainer")
        notesContainer.loadPersistentStores { (storeDescription, error) in
                    if let error = error as NSError? {
                        fatalError("Unresolved error \(error), \(error.userInfo)")
                    }
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
    
    func updateNote(_ note: NoteEntity, title: String, content: String) async {
        notesContainer.viewContext.performAndWait {
            note.title = title
            note.content = content
            saveContext()
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
