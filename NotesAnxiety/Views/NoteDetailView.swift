//
//  NoteDetailView.swift
//  NotesAnxiety
//
//  Reads one journal entry and edits it in place.
//

import SwiftUI

struct NoteDetailView: View {
    @Environment(NotesViewModel.self) private var vm
    let note: NoteEntity

    @State private var isEditing = false
    @State private var title = ""
    @State private var content = ""
    @State private var tags: [String] = []
    @State private var photoPath: String?
    @State private var audioPath: String?
    @State private var confirmDelete = false

    private var ink: Color { vm.skyLevel.sky.ink }

    private var longDate: String {
        (note.timestamp ?? .now).formatted(.dateTime.weekday(.wide).day().month(.wide).hour().minute())
    }

    private var hasContent: Bool {
        !content.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 6) {
                BrandHeader()
                Button {
                    vm.selectedNote = nil
                } label: {
                    Label("Journal", systemImage: "chevron.left")
                        .font(.rounded(.body))
                        .frame(minHeight: 44)
                }
                .buttonStyle(.plain)
                card
                CrisisFooter()
            }
            .frame(maxWidth: 560)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .onAppear { NotificationManager.shared.clearNotification() }
        .confirmationDialog("Delete this note?", isPresented: $confirmDelete, titleVisibility: .visible) {
            Button("Delete", role: .destructive) { vm.deleteNote(note) }
        }
    }

    private var card: some View {
        VStack(alignment: .leading, spacing: 16) {
            header
            if isEditing {
                editor
            } else {
                reader
            }
            Text(note.isWritten ? "Written by you" : "Check-in · no text saved")
                .font(.caption)
                .foregroundStyle(.white.opacity(0.65))
        }
        .padding(24)
        .frame(maxWidth: .infinity, alignment: .leading)
        .skyPanel(fill: 0.12, border: 0.18)
    }

    private var header: some View {
        HStack(spacing: 14) {
            LevelIcon(level: note.level, size: 40)
            VStack(alignment: .leading, spacing: 2) {
                Text(longDate)
                    .font(.footnote)
                    .foregroundStyle(.white.opacity(0.75))
                if let before = note.level {
                    Text(verbatim: "\(before.localizedName) → \(note.settledLevel?.localizedName ?? before.localizedName)")
                        .font(.rounded(.headline, .semibold))
                }
            }
            Spacer(minLength: 0)
            if !isEditing {
                OutlineButton(title: String(localized: "Edit"), systemImage: "pencil", action: startEditing)
            }
        }
    }

    @ViewBuilder
    private var reader: some View {
        Text(note.displayTitle)
            .font(.rounded(.title, .bold))
        if let body = note.content, !body.isEmpty {
            Text(body)
                .font(.title3)
                .foregroundStyle(.white.opacity(0.92))
                .textSelection(.enabled)
        }
        if let photoPath = note.photoPath {
            NotePhoto(path: photoPath)
        }
        if let audioPath = note.audioPath {
            AudioPlayButton(path: audioPath)
        }
        if !note.categories.isEmpty {
            FlowLayout {
                ForEach(note.categories, id: \.self) { tag in
                    Text(tag)
                        .font(.caption.weight(.medium))
                        .padding(.vertical, 4)
                        .padding(.horizontal, 14)
                        .background(.white.opacity(0.16), in: Capsule())
                }
            }
        }
    }

    @ViewBuilder
    private var editor: some View {
        SkyTextField(placeholder: String(localized: "Title"), text: $title)
        SkyTextEditor(placeholder: String(localized: "What's on your mind?"), text: $content)
        AttachmentBar(photoPath: $photoPath, audioPath: $audioPath)
        TagPicker(selection: $tags, tags: editableTags, ink: ink)
        HStack(spacing: 10) {
            PrimaryButton(title: hasContent ? String(localized: "Save changes") : String(localized: "Write something first"), ink: ink) {
                guard hasContent else { return }
                vm.saveEdit(of: note, title: title, content: content, tags: tags, photoPath: photoPath, audioPath: audioPath)
                isEditing = false
            }
            TextActionButton(title: String(localized: "Cancel")) { isEditing = false }
        }
        TextActionButton(title: String(localized: "Delete note"), color: Color(oklch: 0.82, 0.12, 25)) {
            confirmDelete = true
        }
        .frame(maxWidth: .infinity)
    }

    /// The suggested tags plus any this note already has, so older categories
    /// stay selectable and aren't dropped on save.
    private var editableTags: [String] {
        NoteEntity.suggestedTags + note.categories.filter { !NoteEntity.suggestedTags.contains($0) }
    }

    private func startEditing() {
        title = note.title ?? ""
        content = note.content ?? ""
        tags = note.categories
        photoPath = note.photoPath
        audioPath = note.audioPath
        isEditing = true
    }
}
