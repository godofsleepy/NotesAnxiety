//
//  EditNotesView.swift
//  Anxiety Notes
//
//  Created by Filbert Chai on 10/07/24.
//

import SwiftUI
//import JournalingSuggestions

struct EditNotesView: View {
    
    @EnvironmentObject var vm: NotesViewModel
    //    @State var suggestionPhotos = [JournalingSuggestion.Photo]()
    @State private var title: String = ""
    @State private var content: String = ""
    
    @FocusState private var contentEditorInFocus: Bool
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack{
                    //                    ForEach(suggestionPhotos, id: \.photo) { item in
                    //                        AsyncImage(url: item.photo) { image in
                    //                            image.image?
                    //                                .resizable ()
                    //                                .aspectRatio(contentMode: .fit)
                    //                        }
                    //                        .frame(maxHeight: 200)
                    //                    }
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
                        self.updateNote(title: title, content: content)
                    })
                
                TextEditorView(string: $content)
                    .scrollDisabled(true)
                    .font(.title3)
                    .focused($contentEditorInFocus)
                    .onChange(of:content){
                        self.updateNote(title: title, content: content)
                    }
                
                
            }
            .padding(10)
        }
        //        .navigationBarItems(trailing:JournalingSuggestionsPicker {
        //            Text("Picker Label")
        //        } onCompletion: { suggestion in
        //            suggestionPhotos = await suggestion.content(forType: JournalingSuggestion.Photo.self)
        //            print(suggestionPhotos.count)
        //        })
        .navigationBarTitleDisplayMode(.inline)
        .navigationBarBackButtonHidden()
        .navigationBarItems(trailing: HStack {
            Group{
                if(vm.updateProgressState == ProgressState.Loading){
                    ProgressView()
                } else if (vm.updateProgressState == ProgressState.Complete){
                    Label("Saved", systemImage: "checkmark.circle.fill")
                        .labelStyle(.titleAndIcon)

                }
            }.padding(.trailing, 2)
            Menu {
                
                NavigationLink(destination: InsightView(), label: {
                    Label("My Insight", systemImage: "chart.dots.scatter")
                })
                
            } label: {
                Label("", systemImage: "ellipsis.circle")
            }
        })
        .toolbar {
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Spacer()
                    Button("Done") {
                        self.hideKeyboard()
                    }
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    vm.preferredColumn = NavigationSplitViewColumn.sidebar
                }) {
                    Image(systemName: "sidebar.leading")
                }
            }
        }
        .onAppear {
            if let note = vm.selectedNote {
                self.title = note.title ?? ""
                self.content = note.content ?? ""
                NotificationManager.shared.clearNotification()
            }
        }
        
    }
    
    func updateNote(title: String, content: String) {
        
        if (title.isEmpty) && (content.isEmpty) {
            return
        }
        
        vm.performUpdate(title: title, content: content)
    }
}
