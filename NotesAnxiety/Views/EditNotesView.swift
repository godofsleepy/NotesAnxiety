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
    @State private var showAnxiety = false
    @State private var showCamera = false
    @State private var showAudioRecorder = false
    @State private var image: UIImage?
    @State private var audioFilename: URL?
    @State private var pinned = false
    @State private var anxiety: AnxietyModel?
    
    @State private var isShowingTextFormatter = false
    @State private var isShowingVoice = false
    @State private var isShowingLocation = false
    
    @FocusState private var contentEditorInFocus: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                if anxiety != nil {
                    StatusView(
                        anxiety: anxiety!,
                        onDelete: {
                            anxiety = nil
                            updateNote()
                        }
                    )
                }
                TextField(NSLocalizedString("Title", comment: "Greeting"), text: $title, axis: .vertical)
                    .font(.title.bold())
                    .submitLabel(.next)
                    .onChange(of: title, {
                        guard let newValueLastChar = title.last else { return }
                        if newValueLastChar == "\n" {
                            title.removeLast()
                            contentEditorInFocus = true
                        }
                        self.updateNote()
                    })
                
                TextEditorView(string: $content, focus: _contentEditorInFocus)
                    .scrollDisabled(true)
                    .font(.title3)
                    .onChange(of:content){
                        self.updateNote()
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
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarItems(trailing: EditNotesNavBarTrailing(contentEditorInFocus: _contentEditorInFocus))
        .toolbar {
            ToolbarEditNotes(
                showImagePicker: $showImagePicker,
                showAnxiety: $showAnxiety,
                showCamera: $showCamera,
                showAudioRecorder: $showAudioRecorder,
                onCreateNewNote: {
                    vm.selectedNote = nil
                    title = ""
                    content = ""
                    image = nil
                    audioFilename = nil
                    contentEditorInFocus = false
                    pinned = false
                    anxiety = nil
                }
            )
        }
        .sheet(isPresented: $showAnxiety) {
            NavigationStack{
                LogView(showAnxiety: $showAnxiety)
            }
            .tint(Color.white)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerComponent(sourceType: .photoLibrary, selectedImage: $image)
        }
        .sheet(isPresented: $showCamera) {
            ImagePickerComponent(sourceType: .camera, selectedImage: $image)
        }
        .sheet(isPresented: $showAudioRecorder) {
            AudioRecorderComponent(audioFilename: $audioFilename)
                .presentationDetents([.medium])
        }
        .onChange(of: anxiety){
            updateNote()
        }
        
        .onAppear {
            if let note = vm.selectedNote {
                resetNote(newData: note)
                            
                NotificationManager.shared.clearNotification()
            }
        }
    }
    
    func resetNote(newData: NoteModel)  {
        self.audioFilename = nil
        self.title = newData.title ?? ""
        self.content = newData.content ?? ""
        self.pinned = newData.pinned
        self.anxiety = newData.anxiety
        
//        if let photoPath = newData.photoPath, let imageData = try? Data(contentsOf: URL(fileURLWithPath: photoPath)) {
//            self.image = UIImage(data: imageData)
//        } else {
//            self.image = nil
//        }
//        
//        if let audioPath = newData.audioPath {
//            self.audioFilename = URL(fileURLWithPath: audioPath)
//        } else {
//            audioFilename = nil
//        }

    }
    
    //    func loadImageJournalSuggestion(suggestion: JournalingSuggestion)  {
    //        Task {
    //            let content = await suggestion.content(forType: JournalingSuggestion.Photo.self)
    //            print(content.count)
    //            for v in content {
    //                if let uiImage = try? await fetchImage(from: v.photo) {
    //                    // Update the UI on the main thread
    //                    image = uiImage
    //                }
    //            }
    //
    //
    //        }
    //
    //    }
    
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
    
    func updateNote() {
        if  title.isEmpty &&
            content.isEmpty &&
            anxiety == nil
        {
            return
        }
        
        let photoPath = saveImage(image)
        let audioPath = audioFilename?.path
        
        let temporaryNote = TemporaryNoteModel(
            title: title,
            content: content,
            anxiety: anxiety
        )
        
        vm.performUpdate(temporaryNote)
    }
    
    private func fetchImage(from url: URL) async throws -> UIImage? {
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    }
    
    private func deleteNote() {
        Task {
            await vm.deleteNote(vm.selectedNote!)
            DispatchQueue.main.async {
                dismiss()
            }
        }
    }
}
