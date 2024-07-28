//
//  AudioRecorderComponent.swift
//  NotesAnxiety
//
//  Created by Rifat Khadafy on 16/07/24.
//

import SwiftUI
import AVKit

struct AudioRecorderComponent: View {
    @Binding var audioFilename: URL?
    @State private var recording = false
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioPlayer: AVAudioPlayer?
    @State private var isPulsing = false

    var body: some View {
        VStack {
            if recording {
                Text("Tap to stop record..")
                    .foregroundStyle(Color.red)
                    .font(.system(size: 18))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
                
                Button(action: {
                    stopRecording()
                    isPulsing = false
                }){
                    ZStack{
                        Circle()
                            .fill(Color.red)
                            .opacity(0.3)
                            .frame(width: 150, height: 150)
                            
                        Circle()
                            .fill(Color.red)
                            .scaleEffect(isPulsing ? 1.5 : 1.0)
                            .opacity(isPulsing ? 0 : 0.2)
                            .frame(width: 150, height: 150)
                            .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isPulsing)
                     
                        Image(systemName: "stop.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .foregroundStyle(Color.red)
                    }
                    .onAppear{
                        isPulsing = true
                }
                }
            } else {
                Text("Tap to start record..")
                    .foregroundStyle(Color.red)
                    .font(.system(size: 18))
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 40, trailing: 0))
                
                Button(action: {
                    startRecording()
                    isPulsing = false
                }){
                    ZStack{
                        Circle()
                            .fill(Color.red)
                            .opacity(0.3)
                            .frame(width: 150, height: 150)

                        Circle()
                            .fill(Color.red)
                            .scaleEffect(isPulsing ? 2 : 1.0)
                            .opacity(isPulsing ? 0 : 0.2)
                            .frame(width: 150, height: 150)
                            .animation(Animation.easeInOut(duration: 1.0).repeatForever(autoreverses: true), value: isPulsing)
                     
                        Image(systemName: "mic.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .foregroundStyle(Color.red)
                    }
                    .onAppear{
                        isPulsing = true
                }
                }
            }
            
            if let audioFilename = audioFilename {
                Button(action: {
                    playRecording(url: audioFilename)
                }){
                    Image(systemName: "play.circle.fill")
                        .foregroundStyle(Color.red)
                        .font(.system(size: 60))
                        .padding(EdgeInsets(top: 20, leading: 0, bottom: 0, trailing: 0))
                }
            }
        }
        .padding()
    }

    func startRecording() {
        let audioFilename = getDocumentsDirectory().appendingPathComponent(UUID().uuidString + ".m4a")
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]

        do {
            audioRecorder = try AVAudioRecorder(url: audioFilename, settings: settings)
            audioRecorder?.record()
            recording = true
            self.audioFilename = audioFilename
        } catch {
            print("Could not start recording: \(error.localizedDescription)")
        }
    }

    func stopRecording() {
        audioRecorder?.stop()
        recording = false
    }

    func playRecording(url: URL) {
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
        } catch {
            print("Could not play recording: \(error.localizedDescription)")
        }
    }

    func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}
