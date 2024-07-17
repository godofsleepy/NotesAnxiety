//
//  DependencyInjection.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 10/07/24.
//

import Foundation

class DependencyInjection {
    
    static let shared = DependencyInjection()
    private init() {}
    
    lazy var localDataService: LocalDataService = LocalDataServiceImpl()
    
    func notesViewModel() -> NotesViewModel {
        NotesViewModel(localDataService: localDataService)
    }
}
