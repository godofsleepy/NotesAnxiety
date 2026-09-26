//
//  DependencyInjection.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 10/07/24.
//

import Foundation
import SwiftData

@MainActor
final class DependencyInjection {

    static let shared = DependencyInjection()

    let modelContainer: ModelContainer

    private init() {
        do {
            modelContainer = try NoteStore.makeContainer()
        } catch {
            fatalError("Failed to open note store: \(error)")
        }
    }

    lazy var localDataService: LocalDataService = LocalDataServiceImpl(container: modelContainer)

    func notesViewModel() -> NotesViewModel {
        NotesViewModel(localDataService: localDataService)
    }
}
