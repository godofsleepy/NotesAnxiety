//
//  ContentView.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 08/07/24.
//

import SwiftUI

struct ContentView: View {
    @Environment(NotesViewModel.self) private var notesViewModel


    var body: some View {
        @Bindable var notesViewModel = notesViewModel
        NavigationSplitView(preferredCompactColumn: $notesViewModel.preferredColumn) {
            Group{
                if (notesViewModel.isDataLoaded){
                    HistoryNotesView()
                } else {
                    ProgressView("Loading...")
                }
            }.task {
                notesViewModel.fetchNotes()
            }
        } detail: {
            NavigationStack{
                EditNotesView()
            }
        }
    }
}

#Preview {
    ContentView()
        .environment(DependencyInjection.shared.notesViewModel())
}
