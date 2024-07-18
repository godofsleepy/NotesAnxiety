//
//  EditNotesView.swift
//  Anxiety Notes
//
//  Created by Filbert Chai on 10/07/24.
//

import SwiftUI
import JournalingSuggestions

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
    @State private var anxietyLevel: AnxietyTemporaryModel?
    
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
    @State private var currentValue1 = 50.0
    
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
                if anxietyLevel != nil {
                    StatusView(date: anxietyLevel!.createdAt, anxietyImage: "cloud.drizzle.circle.fill", anxietyLabel: AnxietyLevelType.from(average: anxietyLevel!.anxietyLevel).rawValue, anxietyCategory: anxietyLevel!.categoryAnxiety,
                               bgColor: Color(red: 99/255, green: 124/255, blue: 192/255))
                }
                TextField("Title", text: $title, axis: .vertical)
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
//            Group{
//                if(vm.updateProgressState == ProgressState.Loading){
//                    ProgressView()
//                } else if (vm.updateProgressState == ProgressState.Complete){
//                    Label("Saved", systemImage: "checkmark.circle.fill")
//                        .labelStyle(.titleAndIcon)
//
//                }
//            }.padding(.trailing, 2)
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
                    Label("My Insight", systemImage: "chart.dots.scatter")
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
                    if let note = vm.selectedNote {
                        deleteNote(note)
                    }
                }) {
                    Label("Delete", systemImage: "trash")
                }
            } label: {
                Label("", systemImage: "ellipsis.circle")
            }
            if contentEditorInFocus {
                Button("Done") {
                    contentEditorInFocus = false
                }
            }
        })
        .toolbar {
            
            ToolbarItem(placement: .bottomBar, content: {
                HStack{
                    Button(action: { }) {
                        Image(systemName: "textformat")
                    }
                    Spacer()
                    Button(action: { showImagePicker = true }) {
                        Image(systemName: "paperclip")
                    }
                    Spacer()
                    Button(action:{
                        showAnxiety.toggle()
                    }){
                    Image(systemName: "cloud.bolt.fill")
                    }
                    Spacer()
                    Button(action: {
                    }) {
                        Image(systemName: "pencil.tip.crop.circle")
                    }
                    Spacer()
                    Button(action: {
                        // Create New Note
                        vm.selectedNote = nil
                        title = ""
                        content = ""
                        image = nil
                        audioFilename = nil
                        contentEditorInFocus = false
                        pinned = false
                        anxietyLevel = nil
                    }) {
                        Image(systemName: "square.and.pencil")
                    }
                }
            })
            ToolbarItem(placement: .keyboard) {
                HStack {
                    JournalingSuggestionsPicker {
                        Image(systemName: "sparkles")
                    } onCompletion: { suggestion in
//                        print(suggestion.items.count)
//                        print(suggestion.title)
//                        print(suggestion.date)
//                        suggestion.items.forEach { v in
//                            print(v.representations)
//                        }
//                         await suggestion.content(forType: JournalingSuggestion.Photo.self)
//                        print(suggestionPhotos.count)
                    }
//                    Button(action:{
//                        isShowingTextFormatter.toggle()
//                    }){
//                        Image(systemName: "textformat")
//                    }
                    Spacer()
                    Button(action: { showImagePicker = true }) {
                        Image(systemName: "paperclip")
                    }
                    Spacer()
                    Button(action:{
                        showAnxiety.toggle()
                    }){
                    Image(systemName: "cloud.bolt.fill")
                    }
                    Spacer()
                    Button(action: { showCamera = true }) {
                        Image(systemName: "camera")
                    }
                    Spacer()
                    Button(action: { showAudioRecorder = true }) {
                        Image(systemName: "mic")
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
                self.pinned = note.pinned
                self.anxietyLevel = note.anxietyLevel != 0.0 ?
                    AnxietyTemporaryModel(
                        anxietyLevel: note.anxietyLevel,
                        categoryAnxiety: note.categoryAnxiety?.isEmpty == false ? note.categoryAnxiety!.split(separator: ",").map(String.init) : []
                    ) : nil
                
                if let photoPath = note.photoPath, let imageData = try? Data(contentsOf: URL(fileURLWithPath: photoPath)) {
                    self.image = UIImage(data: imageData)
                }
                if let audioPath = note.audioPath {
                    self.audioFilename = URL(fileURLWithPath: audioPath)
                }

                NotificationManager.shared.clearNotification()
            }
        }
        .sheet(isPresented: $showAnxiety) {
            NavigationStack{
                LogView(showAnxiety: $showAnxiety)
            }
            .presentationDetents([.medium])
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
        .onReceive(vm.$temporaryAnxiety, perform: { v in
            if v != nil {
                self.anxietyLevel = v
                self.updateNote(title: title, content: content)
            }
        })
        
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
        
        vm.performUpdate(title: title, content: content, audioPath: audioPath, videoPath: nil, photoPath: photoPath, pinned: pinned, anxiety: anxietyLevel)
    }
    private func deleteNote(_ note: NoteEntity) {
        Task {
            await vm.deleteNote(note)
            DispatchQueue.main.async {
                dismiss()
            }
        }
    }
}
