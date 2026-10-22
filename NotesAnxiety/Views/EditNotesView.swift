//
//  EditNotesView.swift
//  Anxiety Notes
//
//  Created by Filbert Chai on 10/07/24.
//

import SwiftUI
#if canImport(JournalingSuggestions)
import JournalingSuggestions
#endif

struct EditNotesView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Environment(NotesViewModel.self) private var vm
    @State private var title: String = ""
    @State var content: String = ""
    @State private var showImagePicker = false
    @State private var showAnxiety = false
    @State private var showCamera = false
    @State private var showAudioRecorder = false
    @State private var image: UIImage?
    /// Where `image` is saved on disk. Only rewritten when a new image is picked.
    @State private var photoPath: String?
    /// Set by the pickers; moved into `image` and saved once.
    @State private var pickedImage: UIImage?
    @State private var audioFilename: URL?
    @State private var pinned = false
    @State private var anxietyLevel: AnxietyTemporaryModel?
    
    @State private var isShowingTextFormatter = false
    @State private var isShowingVoice = false
    @State private var isShowingLocation = false
    
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
                if let anxietyLevel {
                    StatusView(anxiety: anxietyLevel, onDelete: {
                        vm.temporaryAnxiety = nil
                        self.anxietyLevel = nil
                        updateNote(title: title, content: content)
                    })
                }
                TextField(NSLocalizedString("Title", comment: "Greeting"), text: $title, axis: .vertical)
                    .font(.title.bold())
                    .submitLabel(.next)
                    .focused($contentEditorInFocus)
                    .onChange(of: title, {
                        guard let newValueLastChar = title.last else { return }
                        if newValueLastChar == "\n" {
                            title.removeLast()
                            contentEditorInFocus = true
                        }
                        self.updateNote(title: title, content: content)
                    })
                
                TextEditorView(string: $content, focus: _contentEditorInFocus)
                    .scrollDisabled(true)
                    .font(.title3)
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
        .edgesIgnoringSafeArea(.bottom)
        .navigationBarItems(trailing: EditNotesNavBarTrailing(contentEditorInFocus: _contentEditorInFocus, onDelete: {
            if let note = vm.selectedNote {
                deleteNote(note)
            }
        }))
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
                    photoPath = nil
                    audioFilename = nil
                    contentEditorInFocus = false
                    pinned = false
                    anxietyLevel = nil
                }
            ) {
                journalingSuggestionsButton
            }
        }
        .onAppear {
            if let note = vm.selectedNote {
                
                self.audioFilename = nil
                self.title = note.title ?? ""
                self.content = note.content ?? ""
                self.pinned = note.pinned
                self.anxietyLevel = note.anxietyLevel != 0.0 ?
                    AnxietyTemporaryModel(
                        anxietyLevel: note.anxietyLevel,
                        categoryAnxiety: note.categories,
                        createdAt: note.timestamp ?? Date(), anxietyColor: AnxietyLevelType.color(anxiety: note.anxietyLevel)
                    ) : nil
                
                self.photoPath = note.photoPath
                if let photoPath = note.photoPath, let imageData = try? Data(contentsOf: URL(fileURLWithPath: photoPath)) {
                    self.image = UIImage(data: imageData)
                } else {
                    self.image = nil
                }
                if let audioPath = note.audioPath {
                    self.audioFilename = URL(fileURLWithPath: audioPath)
                } else {
                    audioFilename = nil
                }

                NotificationManager.shared.clearNotification()
            }
        }
        .sheet(isPresented: $showAnxiety) {
            NavigationStack{
                LogView(showAnxiety: $showAnxiety)
            }
            .tint(Color.white)
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePickerComponent(sourceType: .photoLibrary, selectedImage: $pickedImage)
        }
        .sheet(isPresented: $showCamera) {
            ImagePickerComponent(sourceType: .camera, selectedImage: $pickedImage)
        }
        .sheet(isPresented: $showAudioRecorder) {
            AudioRecorderComponent(audioFilename: $audioFilename)
                .presentationDetents([.medium])
        }
        .onChange(of: vm.temporaryAnxiety) {
            if let anxiety = vm.temporaryAnxiety {
                self.anxietyLevel = anxiety
                self.updateNote(title: title, content: content)
            }
        }
        .onChange(of: audioFilename) {
            updateNote(title: title, content: content)
        }
        .onChange(of: pickedImage) {
            guard let pickedImage else { return }
            image = pickedImage
            photoPath = saveImage(pickedImage)
            self.pickedImage = nil
            updateNote(title: title, content: content)
        }
        
    }
    
    // JournalingSuggestions is device-only; the simulator SDK doesn't ship it.
    @ViewBuilder
    private var journalingSuggestionsButton: some View {
        #if canImport(JournalingSuggestions)
        JournalingSuggestionsPicker {
            Image(systemName: "sparkles")
        } onCompletion: { suggestion in
            loadImageJournalSuggestion(suggestion: suggestion)
        }
        #else
        EmptyView()
        #endif
    }

    #if canImport(JournalingSuggestions)
    func loadImageJournalSuggestion(suggestion: JournalingSuggestion)  {
        Task {
            let content = await suggestion.content(forType: JournalingSuggestion.Photo.self)
            print(content.count)
            for v in content {
                if let uiImage = try? await fetchImage(from: v.photo) {
                    pickedImage = uiImage
                }
            }
        }
    }
    #endif
    
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
        
        if title.isEmpty && content.isEmpty && anxietyLevel == nil {
            return
        }
        
        let audioPath = audioFilename?.path
        
        vm.performUpdate(title: title, content: content, audioPath: audioPath, videoPath: nil, photoPath: photoPath, pinned: pinned, anxiety: anxietyLevel)
    }
    private func fetchImage(from url: URL) async throws -> UIImage? {
        let (data, _) = try await URLSession.shared.data(from: url)
        return UIImage(data: data)
    }
    private func deleteNote(_ note: NoteEntity) {
        vm.deleteNote(note)
        dismiss()
    }
}
