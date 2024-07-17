//
//  PersistenceController.swift
//  NotesAnxiety
//
//  Created by Filbert Chai on 15/07/24.
//

import CoreData

struct PersistenceController {
    static let shared = PersistenceController()

    static var preview: PersistenceController = {
        let controller = PersistenceController(inMemory: true)
        let viewContext = controller.container.viewContext
        for i in 0..<10 {
            let newNote = NoteEntity(context: viewContext)
            newNote.timestamp = Date().addingTimeInterval(Double(i) * 60) // Example: Different timestamps for preview
            newNote.title = "Sample Note \(i + 1)"
            newNote.content = "This is a sample note number \(i + 1) for preview purposes."
        }
        do {
            try viewContext.save()
        } catch {
            let nsError = error as NSError
            fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
        }
        return controller
    }()

    let container: NSPersistentContainer

    init(inMemory: Bool = false) {
        container = NSPersistentContainer(name: "YourModelName") // Replace with your actual model name
        if inMemory {
            container.persistentStoreDescriptions.first!.url = URL(fileURLWithPath: "/dev/null")
        }
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
    }

    func fetchNotes() -> [NoteEntity] {
        let request: NSFetchRequest<NoteEntity> = NoteEntity.fetchRequest()
        request.sortDescriptors = [NSSortDescriptor(key: "timestamp", ascending: false)]
        do {
            return try container.viewContext.fetch(request)
        } catch {
            print("Error fetching notes: \(error.localizedDescription)")
            return []
        }
    }
}
