//
//  VoiceRecorderView.swift
//  NotesAnxiety
//
//  Created by Sena Kristiawan on 13/07/24.
//

import SwiftUI

struct VoiceRecorderView: View {
    @ObservedObject var audio : VoiceRecorder
    
    var body: some View {
        VStack{
            Text("Tap to record")
                .foregroundColor(.red)
            Button(action: {
                if audio.recording{
                    audio.stopRecording()
                    if let audioContent = audio.getAudio(){
                        EditNotesView().content += audioContent
                    }
                }else{
                    audio.startRecording()
                }
            }, label: {
                Image(systemName: "mic.circle.fill")
                    .resizable()
                    .scaledToFill()
                    .foregroundColor(audio.recording ? .red : .green)
                    .frame(width: 70, height: 70)
                
            })
        }
        .frame(maxWidth: .infinity, maxHeight: 500)
        .background(Color.black)
    }
}

#Preview {
    VoiceRecorderView(audio: VoiceRecorder())
}
