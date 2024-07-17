import SwiftUI
import AVFoundation

struct AudioRecorderView: View {
    @Binding var audioFilename: URL?
    @State private var recording = false
    @State private var audioRecorder: AVAudioRecorder?
    @State private var audioPlayer: AVAudioPlayer?

    var body: some View {
        VStack {
            if recording {
                Button("Stop Recording") {
                    stopRecording()
                }
            } else {
                Button("Start Recording") {
                    startRecording()
                }
            }
            
            if let audioFilename = audioFilename {
                Button("Play Recording") {
                    playRecording(url: audioFilename)
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
