//
//  SkyComponents.swift
//  NotesAnxiety
//
//  Controls shared by the Sky and Journal screens.
//

import AVFoundation
import SwiftUI
#if canImport(JournalingSuggestions)
import JournalingSuggestions
#endif

extension Font {
    static func rounded(_ style: Font.TextStyle, _ weight: Font.Weight = .medium) -> Font {
        .system(style, design: .rounded, weight: weight)
    }
}

extension View {
    /// The translucent panel used for cards and inputs.
    func skyPanel(cornerRadius: CGFloat = 20, fill: Double = 0.10, border: Double = 0.16) -> some View {
        background(.white.opacity(fill), in: RoundedRectangle(cornerRadius: cornerRadius))
            .overlay(RoundedRectangle(cornerRadius: cornerRadius).strokeBorder(.white.opacity(border)))
    }
}

struct BrandHeader: View {
    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: "cloud.fill")
                .font(.system(size: 20))
            Text(verbatim: "Notes Anxiety")
                .font(.rounded(.headline, .semibold))
            Spacer()
        }
        .frame(height: 56)
    }
}

struct CrisisFooter: View {
    var body: some View {
        Text("A reflection tool, not therapy. In crisis in Indonesia, call 119 ext 8.")
            .font(.caption)
            .foregroundStyle(.white.opacity(0.65))
            .multilineTextAlignment(.center)
            .frame(maxWidth: .infinity)
            .padding(.top, 40)
            .padding(.bottom, 16)
    }
}

/// The 3D mascot, with the design's slow float or breathing motion.
struct CloudHero: View {
    enum Motion { case float, breathe }

    let level: AnxietyLevelType
    var size: CGFloat = 210
    var motion: Motion = .float

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var body: some View {
        CloudScene(anxietyLevelType: level)
            .frame(width: size * 300 / 210, height: size * 250 / 210)
            .phaseAnimator([false, true]) { view, raised in
                view
                    .offset(y: raised && motion == .float && !reduceMotion ? -8 : 0)
                    .scaleEffect(raised && motion == .breathe && !reduceMotion ? 1.06 : 1)
            } animation: { _ in
                .easeInOut(duration: motion == .breathe ? 4 : 2.5)
            }
            .accessibilityLabel(level.localizedName)
    }
}

/// A flat weather glyph for a level; a dimmed cloud marks notes with no check-in.
struct LevelIcon: View {
    let level: AnxietyLevelType?
    var size: CGFloat = 26

    var body: some View {
        Image(systemName: level?.icon ?? "cloud")
            .font(.system(size: size))
            .symbolRenderingMode(.monochrome)
            .opacity(level == nil ? 0.5 : 1)
            .frame(width: size * 1.3, height: size * 1.2)
            .accessibilityHidden(true)
    }
}

struct PrimaryButton: View {
    let title: String
    let ink: Color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.rounded(.body, .semibold))
                .foregroundStyle(ink)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .padding(.horizontal, 20)
                .background(.white, in: Capsule())
                .shadow(color: .black.opacity(0.15), radius: 15, y: 8)
        }
        .buttonStyle(.plain)
    }
}

struct TextActionButton: View {
    let title: String
    var color: Color = .white.opacity(0.85)
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.rounded(.subheadline))
                .foregroundStyle(color)
                .frame(minHeight: 44)
                .padding(.horizontal, 16)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

struct OutlineButton: View {
    let title: String
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Label(title, systemImage: systemImage)
                .font(.rounded(.subheadline))
                .foregroundStyle(.white)
                .frame(minHeight: 44)
                .padding(.horizontal, 16)
                .background(.white.opacity(0.08), in: Capsule())
                .overlay(Capsule().strokeBorder(.white.opacity(0.22)))
        }
        .buttonStyle(.plain)
    }
}

struct Chip<Icon: View>: View {
    let title: String
    let isOn: Bool
    let ink: Color
    var compact = false
    let action: () -> Void
    @ViewBuilder var icon: Icon

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                icon
                Text(title)
            }
            .font(compact ? .rounded(.footnote) : .rounded(.subheadline))
            .foregroundStyle(isOn ? ink : .white)
            .padding(.vertical, compact ? 4 : 6)
            .padding(.horizontal, compact ? 10 : 14)
            .background(isOn ? Color.white : Color.white.opacity(0.10), in: Capsule())
            .overlay(Capsule().strokeBorder(.white.opacity(0.2)))
        }
        .buttonStyle(.plain)
        .accessibilityAddTraits(isOn ? .isSelected : [])
    }
}

extension Chip where Icon == EmptyView {
    init(title: String, isOn: Bool, ink: Color, compact: Bool = false, action: @escaping () -> Void) {
        self.init(title: title, isOn: isOn, ink: ink, compact: compact, action: action) { EmptyView() }
    }
}

/// Lays children out left to right, wrapping onto new rows.
struct FlowLayout: Layout {
    var spacing: CGFloat = 6

    func sizeThatFits(proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) -> CGSize {
        let frames = arrange(subviews, width: proposal.width ?? .infinity)
        return CGSize(
            width: frames.map(\.maxX).max() ?? 0,
            height: frames.map(\.maxY).max() ?? 0
        )
    }

    func placeSubviews(in bounds: CGRect, proposal: ProposedViewSize, subviews: Subviews, cache: inout ()) {
        let frames = arrange(subviews, width: bounds.width)
        for (subview, frame) in zip(subviews, frames) {
            subview.place(at: CGPoint(x: bounds.minX + frame.minX, y: bounds.minY + frame.minY), proposal: ProposedViewSize(frame.size))
        }
    }

    private func arrange(_ subviews: Subviews, width: CGFloat) -> [CGRect] {
        var frames: [CGRect] = []
        var x: CGFloat = 0
        var y: CGFloat = 0
        var rowHeight: CGFloat = 0
        for subview in subviews {
            let size = subview.sizeThatFits(.unspecified)
            if x > 0, x + size.width > width {
                x = 0
                y += rowHeight + spacing
                rowHeight = 0
            }
            frames.append(CGRect(origin: CGPoint(x: x, y: y), size: size))
            x += size.width + spacing
            rowHeight = max(rowHeight, size.height)
        }
        return frames
    }
}

struct TagPicker: View {
    @Binding var selection: [String]
    let tags: [String]
    let ink: Color

    var body: some View {
        FlowLayout {
            ForEach(tags, id: \.self) { tag in
                Chip(title: tag, isOn: selection.contains(tag), ink: ink) {
                    if selection.contains(tag) {
                        selection.removeAll { $0 == tag }
                    } else {
                        selection.append(tag)
                    }
                }
            }
        }
    }
}

struct SkyTextField: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        TextField("", text: $text, prompt: Text(placeholder).foregroundStyle(.white.opacity(0.6)))
            .font(.rounded(.headline, .semibold))
            .foregroundStyle(.white)
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .skyPanel(cornerRadius: 8, fill: 0.12, border: 0.18)
    }
}

struct SkyTextEditor: View {
    let placeholder: String
    @Binding var text: String

    var body: some View {
        TextEditor(text: $text)
            .font(.body)
            .foregroundStyle(.white)
            .scrollContentBackground(.hidden)
            .frame(minHeight: 170)
            .padding(10)
            .overlay(alignment: .topLeading) {
                if text.isEmpty {
                    Text(placeholder)
                        .foregroundStyle(.white.opacity(0.6))
                        .padding(.vertical, 18)
                        .padding(.horizontal, 15)
                        .allowsHitTesting(false)
                }
            }
            .skyPanel(fill: 0.12, border: 0.18)
    }
}

/// A saved photo, with an optional remove control.
struct NotePhoto: View {
    let path: String
    var onRemove: (() -> Void)?

    var body: some View {
        if let image = UIImage(contentsOfFile: path) {
            Image(uiImage: image)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(alignment: .topTrailing) {
                    if let onRemove {
                        Button(action: onRemove) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.title2)
                                .symbolRenderingMode(.palette)
                                .foregroundStyle(.white, .black.opacity(0.5))
                                .padding(6)
                        }
                        .accessibilityLabel("Remove photo")
                    }
                }
        }
    }
}

struct AudioPlayButton: View {
    let path: String
    @State private var player: AVAudioPlayer?

    var body: some View {
        OutlineButton(title: String(localized: "Play recording"), systemImage: "play.fill") {
            player = try? AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            player?.play()
        }
    }
}

/// Photo, camera, voice and (on device) Journaling Suggestions attachments.
struct AttachmentBar: View {
    @Binding var photoPath: String?
    @Binding var audioPath: String?

    @State private var showLibrary = false
    @State private var showCamera = false
    @State private var showRecorder = false
    @State private var pickedImage: UIImage?

    private var audioURL: Binding<URL?> {
        Binding(
            get: { audioPath.map { URL(fileURLWithPath: $0) } },
            set: { audioPath = $0?.path }
        )
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            if let photoPath {
                NotePhoto(path: photoPath) { self.photoPath = nil }
            }
            HStack(spacing: 20) {
                button("paperclip", label: "Add photo") { showLibrary = true }
                if UIImagePickerController.isSourceTypeAvailable(.camera) {
                    button("camera", label: "Take photo") { showCamera = true }
                }
                button(audioPath == nil ? "mic" : "mic.fill", label: "Record audio") { showRecorder = true }
                journalingSuggestionsButton
            }
            .font(.title3)
            .foregroundStyle(.white)
        }
        .sheet(isPresented: $showLibrary) {
            ImagePickerComponent(sourceType: .photoLibrary, selectedImage: $pickedImage)
        }
        .sheet(isPresented: $showCamera) {
            ImagePickerComponent(sourceType: .camera, selectedImage: $pickedImage)
        }
        .sheet(isPresented: $showRecorder) {
            AudioRecorderComponent(audioFilename: audioURL)
                .presentationDetents([.medium])
        }
        .onChange(of: pickedImage) {
            guard let pickedImage else { return }
            photoPath = save(pickedImage)
            self.pickedImage = nil
        }
    }

    private func button(_ systemImage: String, label: LocalizedStringKey, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .frame(minWidth: 44, minHeight: 44)
        }
        .buttonStyle(.plain)
        .accessibilityLabel(label)
    }

    private func save(_ image: UIImage) -> String? {
        guard let data = image.jpegData(compressionQuality: 1.0) else { return nil }
        let url = URL.documentsDirectory.appending(path: UUID().uuidString + ".jpg")
        do {
            try data.write(to: url)
            return url.path
        } catch {
            print("Failed to save image: \(error)")
            return nil
        }
    }

    // JournalingSuggestions is device-only; the simulator SDK doesn't ship it.
    @ViewBuilder
    private var journalingSuggestionsButton: some View {
        #if canImport(JournalingSuggestions)
        JournalingSuggestionsPicker {
            Image(systemName: "sparkles")
                .frame(minWidth: 44, minHeight: 44)
        } onCompletion: { suggestion in
            loadPhoto(from: suggestion)
        }
        #endif
    }

    #if canImport(JournalingSuggestions)
    private func loadPhoto(from suggestion: JournalingSuggestion) {
        // JournalingSuggestion isn't Sendable, but only this task reads it.
        nonisolated(unsafe) let suggestion = suggestion
        Task {
            let photos = await suggestion.content(forType: JournalingSuggestion.Photo.self)
            for photo in photos {
                if let (data, _) = try? await URLSession.shared.data(from: photo.photo),
                   let image = UIImage(data: data) {
                    pickedImage = image
                }
            }
        }
    }
    #endif
}
