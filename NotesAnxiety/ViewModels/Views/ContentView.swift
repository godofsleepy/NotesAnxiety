//
//  ContentView.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 08/07/24.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var notesViewModel: NotesViewModel
    @State private var preferredColumn = NavigationSplitViewColumn.detail


    var body: some View {
        NavigationSplitView(preferredCompactColumn: $preferredColumn) {
            Group{
                if (notesViewModel.isDataLoaded){
                    HistoryNotesView()
                } else {
                    ProgressView("Loading...")
                }
            }.task {
                await notesViewModel.fetchNotes()
            }
        } detail: {
            NavigationStack{
                EditNotesView()
            }
        }
        .onReceive(notesViewModel.$preferredColumn, perform: { changes in
            preferredColumn = changes
        })
    }
}

#Preview {
    ContentView()
}
