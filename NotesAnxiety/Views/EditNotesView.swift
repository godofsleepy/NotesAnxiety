//
//  EditNotesView.swift
//  Anxiety Notes
//
//  Created by Filbert Chai on 10/07/24.
//

import SwiftUI
import JournalingSuggestions

struct EditNotesView: View {
    
    @EnvironmentObject var vm: NotesViewModel
    @State var suggestionPhotos = [JournalingSuggestion.Photo]()
    @State var note: NoteEntity?
    @State private var title: String = ""
    @State private var journalingSuggestion: JournalingSuggestion?
    @State private var content: String = ""
    
    @FocusState private var contentEditorInFocus: Bool

    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack{
                    ForEach(suggestionPhotos, id: \.photo) { item in
                        AsyncImage(url: item.photo) { image in
                            image.image?
                                .resizable ()
                                .aspectRatio(contentMode: .fit)
                        }
                        .frame(maxHeight: 200)
                    }
                }
                TextField("Title", text: $title, axis: .vertical)
                    .font(.title.bold())
                    .submitLabel(.next)
                    .onChange(of: title, {
                        guard let newValueLastChar = title.last else { return }
                        if newValueLastChar == "\n" {
                            title.removeLast()
                            contentEditorInFocus = true
                        }
                    })
                    
                TextEditorView(string: $content)
                    .scrollDisabled(true)
                    .font(.title3)
                .focused($contentEditorInFocus)
                
    
            }
            .padding(10)
        }
        .navigationBarItems(trailing:JournalingSuggestionsPicker {
            Text("Picker Label")
        } onCompletion: { suggestion in
            journalingSuggestion = suggestion
            suggestionPhotos = await suggestion.content(forType: JournalingSuggestion.Photo.self)
            print(suggestionPhotos.count)
        })
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("Done") {
                        self.hideKeyboard()
                        // Save to Core Data
                        self.updateNote(title: title, content: content)
                    }
                }
            }
        }
        .onAppear {
            
            if let note = note {
                self.title = note.title ?? ""
                self.content = note.content ?? ""
            }
        }
                    
    }
    
    // MARK: Core Data Operations

    func updateNote(title: String, content: String) {
        
        if (title.isEmpty) && (content.isEmpty) {
            return
        }
        
        guard let note = note else { return }
        
        Task {
            await vm.updateNote(note, title: title, content: content)
        }
    }
}
