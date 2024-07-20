//
//  EditNotesNavBarTrailing.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 20/07/24.
//

import SwiftUI

struct EditNotesNavBarTrailing: View {
    @FocusState var contentEditorInFocus: Bool
    
    var body: some View {
        HStack {
            Menu {
                ControlGroup{
                    Button { } label: {
                        Text("Share")
                        Image(systemName: "square.and.arrow.up")
                    }
                    
                    Button { } label: {
                        Text("Pin")
                        Image(systemName: "pin.fill")
                    }
                    
                    Button { } label: {
                        Text("Lock")
                        Image(systemName: "lock.fill")
                    }
                }
                NavigationLink(destination: InsightView(), label: {
                    Label(NSLocalizedString("My Insight", comment: "Greeting"), systemImage: "chart.dots.scatter")
                })
                Button(action: {}) {
                    Label("Find in Note", systemImage: "magnifyingglass")
                }
                Button(action: {}) {
                    Label("Move Note", systemImage: "folder")
                }
                Button(action: {}) {
                    Label("Recent Note", systemImage: "clock")
                }
                Button(action: {}) {
                    Label("Line & Grids", systemImage: "rectangle.split.3x3")
                }
                Button(action: {}) {
                    Label("Attachment View", systemImage: "rectangle.3.group")
                }
                Button(role:.destructive, action: {
//                    if let note = vm.selectedNote {
//                        deleteNote(note)
//                    }
                }) {
                    Label(NSLocalizedString("Delete", comment: "Greeting"), systemImage: "trash")
                }
            } label: {
                Label("", systemImage: "ellipsis.circle")
            }
            if contentEditorInFocus {
                Button("Done") {
                    contentEditorInFocus = false
                }
            }
        }
    }
}

