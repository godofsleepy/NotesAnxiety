//
//  NotesAnxietyApp.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 08/07/24.
//

import SwiftUI

@main
struct NotesAnxietyApp: App {
    
    @StateObject var dependencyInjection: DependencyInjection
    
    init() {
        let depen1 = DependencyInjection()
        _dependencyInjection = StateObject(wrappedValue: depen1)
    }
    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    await dependencyInjection.initialize()
                }
                .environmentObject(dependencyInjection.notesViewModel())
                
        }
    }
}
