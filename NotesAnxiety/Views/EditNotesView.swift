//
//  EditNotesView.swift
//  Anxiety Notes
//
//  Created by Filbert Chai on 10/07/24.
//

import SwiftUI
//import JournalingSuggestions

struct EditNotesView: View {
    @Environment(\.dismiss) private var dismiss
    
    @EnvironmentObject var vm: NotesViewModel
    @State private var title: String = ""
    @State var content: String = ""
    @State private var showImagePicker = false
    @State private var showCamera = false
    @State private var showAudioRecorder = false
    @State private var image: UIImage?
    @State private var audioFilename: URL?
    @State private var pinned = false
    
    @State private var isShowingTextFormatter = false
    @State private var isShowingVoice = false
    @State private var isShowingLocation = false
    
    @State var titleIsPressed = false
    @State var headingIsPressed = false
    @State var subHeadingIsPressed = false
    @State var bodyIsPressed = false
    @State var monostyledIsPressed = false
    
    @State var boldIsPressed = false
    @State var italicIsPressed = false
    @State var underlineIsPressed = false
    @State var strikeThroughIsPressed = false
        
    @State var bulletIsPressed = false
    @State var listIsPressed = false
    @State var numberIsPressed = false
    @State var alignLeftIsPressed = false
    @State var alignRightIsPressed = false
    
    @FocusState private var contentEditorInFocus: Bool
    
    var body: some View {
        
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
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
                
                if let image = image {
                    Image(uiImage: image)
                        .resizable()
                        .scaledToFit()
                }

            }
            .padding(10)
        }
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
            
            ToolbarItem(placement: .bottomBar, content: {
                HStack{
                    Spacer()
                    Button(action: {
                        vm.selectedNote = nil
                        title = ""
                        content = ""
                        image = nil
                        audioFilename = nil
                        contentEditorInFocus = false
                        pinned = false
                    }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            })
            ToolbarItem(placement: .keyboard) {
                HStack {
                    Button(action:{
                        isShowingTextFormatter.toggle()
                    }){
                        Image(systemName: "textformat")
                    }
                    
                    Button(action:{ }){
                    Image(systemName: "cloud.bolt.fill")
                    }
                    Button(action:{ isShowingLocation = true }){
                        Image(systemName: "location")
                    }
                    Button(action:{}){
                        Image(systemName: "doc")
                    }
                    
                    Button(action: { showImagePicker = true }) {
                        Image(systemName: "paperclip")
                    }
                    Button(action: { showCamera = true }) {
                        Image(systemName: "camera")
                    }
                    Button(action: { showAudioRecorder = true }) {
                        Image(systemName: "mic")
                    }
                    Spacer()
                   
                    Button("Done") {
                        self.hideKeyboard()
                    }
                }
            }
            ToolbarItem(placement: .navigationBarLeading) {
                Button(action: {
                    dismiss()
                }) {
                    Image(systemName: "sidebar.leading")
                }
            }
        }
        .onAppear {
            if let note = vm.selectedNote {
                self.title = note.title ?? ""
                self.content = note.content ?? ""
                self.pinned = note.pinned ?? false
                
                if let photoPath = note.photoPath, let imageData = try? Data(contentsOf: URL(fileURLWithPath: photoPath)) {
                    self.image = UIImage(data: imageData)
                }
                if let audioPath = note.audioPath {
                    self.audioFilename = URL(fileURLWithPath: audioPath)
                }

                NotificationManager.shared.clearNotification()
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerComponent(sourceType: .photoLibrary, selectedImage: $image)
        }
        .sheet(isPresented: $showCamera) {
            ImagePickerComponent(sourceType: .camera, selectedImage: $image)
        }
        .sheet(isPresented: $showAudioRecorder) {
            AudioRecorderComponent(audioFilename: $audioFilename)
        }
        
    }
    
    func saveImage(_ image: UIImage?) -> String? {
        guard let image = image, let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        let filename = getDocumentsDirectory().appendingPathComponent(UUID().uuidString + ".jpg")
        try? data.write(to: filename)
        return filename.path
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    func updateNote(title: String, content: String) {
        
        if (title.isEmpty) && (content.isEmpty) {
            return
        }
        
        let photoPath = saveImage(image)
        let audioPath = audioFilename?.path
        
        vm.performUpdate(title: title, content: content, audioPath: audioPath, videoPath: nil, photoPath: photoPath, pinned: pinned )
    }
}
