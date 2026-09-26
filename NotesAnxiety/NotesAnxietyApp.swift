//
//  NotesAnxietyApp.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 08/07/24.
//

import SwiftUI

@main
struct NotesAnxietyApp: App {
    @State private var notesViewModel = DependencyInjection.shared.notesViewModel()

    var body: some Scene {
        WindowGroup {
            ContentView()
                .task {
                    NotificationManager.shared.requestAuthorization()
                    NotificationManager.shared.scheduleNotification(trigger: .calendar)
                }
                .environment(notesViewModel)
                
        }
    }
}
