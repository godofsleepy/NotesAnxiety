//
//  EditNotesView.swift
//  Anxiety Notes
//
//  Created by Filbert Chai on 10/07/24.
//

import SwiftUI
import JournalingSuggestions
import PhotosUI

struct EditNotesView: View {
    
    @EnvironmentObject var vm: NotesViewModel
    @State var suggestionPhotos = [JournalingSuggestion.Photo]()
    @State var note: NoteEntity?
    @State private var title: String = ""
    @State private var journalingSuggestion: JournalingSuggestion?
    @State var content: String = ""
    @State private var textFormatter = false
    @State private var isShowingCamera = false
    @State private var isShowingVoice = false
    @State private var isShowingLocation = false
    @State private var isShowingAnxiety = false
    @State private var isShowingDoc = false
    @State private var selectedImage: UIImage?
    @State private var imageItem: PhotosPickerItem?
    @State var image: UIImage?
//    @State var audio: AVAudioFile
    
    @State public var titleIsPressed = false
    @State public var headingIsPressed = false
    @State public var subHeadingIsPressed = false
    @State public var bodyIsPressed = false
    @State public var monostyledIsPressed = false
    
    @State public var boldIsPressed = false
    @State public var italicIsPressed = false
    @State public var underlineIsPressed = false
    @State public var strikeThroughIsPressed = false
    
    @State public var bulletIsPressed = false
    @State public var listIsPressed = false
    @State public var numberIsPressed = false
    @State public var alignLeftIsPressed = false
    @State public var alignRightIsPressed = false
    
    
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
                
                TextEditorView(string: $content, image: $image)
                    .scrollDisabled(true)
                    .font(.title3)
                    .focused($contentEditorInFocus)
            }
            .padding(10)
            
//            if let image = image {
//                Image(uiImage: image)
//                    .resizable()
//                    .scaledToFit()
//            }
            
//            if let audio = audio {
//                
//            }

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
                    Button(action:{
                        textFormatter.toggle()
                    }){
                        Image(systemName: "textformat")
                    }
                    Spacer()
                    Button("Done") {
                        self.hideKeyboard()
                        // Save to Core Data
                        updateNote(title: title, content: content)
                    }
                    Button(action:{
                        isShowingCamera = true
                    }){
                        Image(systemName: "camera")
                        
                    }
                    
                    Button(action:{
                        isShowingVoice = true
                        
                    }){
                        Image(systemName: "waveform")
                    }
                    
                    Button(action:{
                        isShowingAnxiety = true
                        
                    }){
                        Image(systemName: "cloud.bolt.fill")
                    }
                    Button(action:{
                        isShowingLocation = true
                        
                    }){
                        Image(systemName: "location")
                    }
                    
                    Button(action:{
                        isShowingDoc = true
                    }){
                        Image(systemName: "doc")
                    }
                    .fileImporter(isPresented: $isShowingDoc, allowedContentTypes: [.item], allowsMultipleSelection: true, onCompletion: { results in
                                    
                                    switch results {
                                    case .success(let fileurls):
                                        print(fileurls.count)
                                        
                                        
                                        for fileurl in fileurls {
                                            print(fileurl.path)
                                        }
                                        
                                    case .failure(let error):
                                        print(error)
                                    }
                                    
                                })
                    Button(action:{
                        
                    }){
                        Image(systemName: "pencil.tip.crop.circle")
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
        .sheet(isPresented: $textFormatter){
            TextFormatter(boldIsPressed: $boldIsPressed, italicIsPressed: $italicIsPressed, monospaceIsPressed: $monostyledIsPressed, strikeIsPressed: $strikeThroughIsPressed, realContent: $content)
                .presentationDetents([.height(200)])
        }
        .sheet(isPresented: $isShowingAnxiety){
            AnxietyTrackerView()
                .presentationDetents([.height(200)])
        }
        .sheet(isPresented: $isShowingVoice){
//            AudioRecorderView(audioFilename: audio)
            TextFormatter(boldIsPressed: $boldIsPressed, italicIsPressed: $italicIsPressed, monospaceIsPressed: $monostyledIsPressed, strikeIsPressed: $strikeThroughIsPressed, realContent: $content)
                .presentationDetents([.height(200)])
        }
        .sheet(isPresented: $isShowingCamera, onDismiss: {self.isShowingCamera = false}) {
                    CameraViewController(photo: $image)
                }

    }
    
    func getTitleIsPressed() -> Bool{
        return titleIsPressed
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
