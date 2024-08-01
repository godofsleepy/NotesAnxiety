//
//  ToolbarEditNotes.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 20/07/24.
//

import Foundation
import SwiftUI

struct ToolbarEditNotes : ToolbarContent {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var showImagePicker: Bool
    @Binding var showAnxiety: Bool
    @Binding var showCamera: Bool
    @Binding var showAudioRecorder: Bool
    var onCreateNewNote: () -> Void
    
    var body: some ToolbarContent {
        ToolbarItem(placement: .keyboard) {
            HStack {
                //                    JournalingSuggestionsPicker {
                //                        Image(systemName: "sparkles")
                //                    } onCompletion: { suggestion in
                //                        //                        print(suggestion.items.count)
                //                        //                        print(suggestion.title)
                //                        //                        print(suggestion.date)
                //                        //                        suggestion.items.forEach { v in
                //                        //                            print(v.representations)
                //                        //                        }
                //                        loadImageJournalSuggestion(suggestion: suggestion)
                //                    }
                //                    Button(action:{
                //                        isShowingTextFormatter.toggle()
                //                    }){
                //                        Image(systemName: "textformat")
                //                    }
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
}
