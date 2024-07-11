//
//  NotesAnxietyApp.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 08/07/24.
//

import SwiftUI

@main
struct NotesAnxietyApp: App {
    let coreDataManager = LocalDataServiceImpl()
    @StateObject var notesViewModel: NotesViewModel
    

        init() {
            let viewModel = NotesViewModel(manager: coreDataManager)
            _notesViewModel = StateObject(wrappedValue: viewModel)
        }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(notesViewModel)
        }
    }
}
