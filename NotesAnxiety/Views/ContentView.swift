//
//  ContentView.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 08/07/24.
//

import SwiftUI
import HealthKit

struct ContentView: View {
    @EnvironmentObject var notesViewModel: NotesViewModel

    var body: some View {
//        Keyboard()
        
        Group {
            if notesViewModel.isDataLoaded {
                NotesView()
            } else {
                ProgressView("Loading...")
            }
        }.task {
            await notesViewModel.fetchNotes()
        }
    }
}

#Preview {
    ContentView()
}
