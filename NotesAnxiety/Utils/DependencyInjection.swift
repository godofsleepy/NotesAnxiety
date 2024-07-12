//
//  DependencyInjection.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 10/07/24.
//

import Foundation

class DependencyInjection: ObservableObject {
    
    lazy var localDataService: LocalDataService = LocalDataServiceImpl()
    
    func initialize() async {
        
    }
    
    func notesViewModel() -> NotesViewModel {
        NotesViewModel(localDataService: localDataService)
    }
}
