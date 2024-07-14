//
//  VoiceRecorder.swift
//  NotesAnxiety
//
//  Created by Sena Kristiawan on 13/07/24.
//

import Foundation
import SwiftUI
import Combine
import AVFoundation

class VoiceRecorder: ObservableObject{
    let objectWillChange = PassthroughSubject<VoiceRecorder, Never>()
    var voiceRecorder: AVAudioRecorder!
    var recording = false {
        didSet{
            objectWillChange.send(self)
        }
    }
    
    func startRecording(){
        let recordingSession = AVAudioSession.sharedInstance()
        do{
            try recordingSession.setCategory(.playAndRecord, mode: .default)
            try recordingSession.setActive(true)
        }catch{
            print("Failed to record a session")
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        
        let docPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let audioFileName = docPath.appendingPathComponent("\(dateFormatter.string(from: Date()))Record.m4a")
        
        let settings = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 12000,
            AVNumberOfChannelsKey: 1,
            AVEncoderBitRateKey: AVAudioQuality.high.rawValue
        ]
        
        do{
            voiceRecorder = try AVAudioRecorder(url: audioFileName, settings: settings)
            voiceRecorder.record()
            
            recording = true

        }catch{
            print("Couldnt start recording")
        }
        
        
    }
    
    func stopRecording(){
        voiceRecorder.stop()
        recording = false
        
    }
    
    func getAudio() -> String? {
        do{
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let result = try FileManager.default.contentsOfDirectory(at: url, includingPropertiesForKeys: nil, options: .producesRelativePathURLs)
            
            if let lastAudioFileUrl = result.last{
                let audioData = try Data(contentsOf: lastAudioFileUrl)
                return String(data: audioData, encoding: .utf8)
                
            }
        }catch{
            print("cant find the one u lookin for")
        }
        return nil
    }
}
