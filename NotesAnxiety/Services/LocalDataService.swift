//
//  LocalDataService.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 10/07/24.
//

import Foundation
import CoreData

protocol LocalDataService {
    func fetchNotes(searchText: String) async -> Result<[NoteEntity], Error>
}

class LocalDataServiceImpl {
    let container: NSPersistentContainer
    
    init() {
        container = NSPersistentContainer(name: "NotesContainer")
    }
    
    func loadCoreData(completion: @escaping (Bool) -> Void) {
        container.loadPersistentStores { description, error in
            DispatchQueue.main.async {
                if let error = error {
                    print("Core Data loading error: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        }
    }

}
