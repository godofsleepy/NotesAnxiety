//
//  ToolbarEditNotes.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 20/07/24.
//

import Foundation
import SwiftUI

struct ToolbarEditNotes<SuggestionsButton: View> : ToolbarContent {
    @Environment(\.dismiss) private var dismiss

    @Binding var showImagePicker: Bool
    @Binding var showAnxiety: Bool
    @Binding var showCamera: Bool
    @Binding var showAudioRecorder: Bool
    var onCreateNewNote: () -> Void
    @ViewBuilder var suggestionsButton: SuggestionsButton

    var body: some ToolbarContent {
        ToolbarItem(placement: .bottomBar) {
            HStack {
                suggestionsButton
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
                Button(action: { showAudioRecorder = true }) {
                    Image(systemName: "mic")
                }
                Spacer()
                Button(action: onCreateNewNote) {
                    Image(systemName: "square.and.pencil")
                }
            }
        }
        ToolbarItem(placement: .keyboard) {
            HStack {
                suggestionsButton
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
}
