//
//  JournalView.swift
//  NotesAnxiety
//
//  The Journal tab: searchable, filterable note list.
//

import SwiftUI

struct JournalView: View {
    @Environment(NotesViewModel.self) private var vm
    @State private var query = ""
    @State private var mood: AnxietyLevelType?
    @State private var tag: String?
    @State private var onlyWritten = false
    @State private var showInsight = false
    @State private var noteToDelete: NoteEntity?

    private var ink: Color { vm.skyLevel.sky.ink }

    private var filtered: [NoteEntity] {
        vm.notes.filter { note in
            (mood == nil || note.level == mood)
                && (tag == nil || note.categories.contains(tag!))
                && (!onlyWritten || note.isWritten)
                && (query.isEmpty || note.searchText.localizedCaseInsensitiveContains(query))
        }
    }

    private var sections: [(title: LocalizedStringKey, notes: [NoteEntity])] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        let last7 = calendar.date(byAdding: .day, value: -7, to: today)!
        let last30 = calendar.date(byAdding: .day, value: -30, to: today)!
        let unpinned = filtered.filter { !$0.pinned }
        func day(_ note: NoteEntity) -> Date { calendar.startOfDay(for: note.timestamp ?? .distantPast) }
        let all: [(LocalizedStringKey, [NoteEntity])] = [
            ("Pinned", filtered.filter(\.pinned)),
            ("Today", unpinned.filter { day($0) >= today }),
            ("Last 7 Days", unpinned.filter { day($0) < today && day($0) >= last7 }),
            ("Last 30 Days", unpinned.filter { day($0) < last7 && day($0) >= last30 }),
            ("Older", unpinned.filter { day($0) < last30 }),
        ]
        return all.filter { !$0.1.isEmpty }
    }

    private var tags: [String] {
        var seen = Set<String>()
        return vm.notes.flatMap(\.categories).filter { seen.insert($0).inserted }
    }

    var body: some View {
        if let note = vm.selectedNote {
            NoteDetailView(note: note)
                .id(note.id)
        } else {
            list
        }
    }

    private var list: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 10) {
                BrandHeader()
                HStack {
                    Text("Journal")
                        .font(.rounded(.largeTitle, .bold))
                    Spacer()
                    Button {
                        showInsight = true
                    } label: {
                        Image(systemName: "chart.dots.scatter")
                            .frame(minWidth: 44, minHeight: 44)
                    }
                    .buttonStyle(.plain)
                    .accessibilityLabel("My Insight")
                }
                .padding(.top, 14)
                searchField
                filters
                if sections.isEmpty {
                    Text("Nothing here yet. Clear skies.")
                        .foregroundStyle(.white.opacity(0.78))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                }
                ForEach(Array(sections.enumerated()), id: \.offset) { _, section in
                    Text(section.title)
                        .font(.rounded(.footnote))
                        .foregroundStyle(.white.opacity(0.72))
                        .padding(.top, 10)
                    VStack(spacing: 0) {
                        ForEach(section.notes) { note in
                            row(note)
                            if note != section.notes.last {
                                Divider().overlay(.white.opacity(0.1))
                            }
                        }
                    }
                    .skyPanel(border: 0.14)
                }
                CrisisFooter()
            }
            .frame(maxWidth: 560)
            .frame(maxWidth: .infinity)
            .padding(.horizontal, 16)
        }
        .scrollIndicators(.hidden)
        .scrollDismissesKeyboard(.interactively)
        .sheet(isPresented: $showInsight) {
            NavigationStack {
                InsightView()
                    .toolbar {
                        ToolbarItem(placement: .topBarTrailing) {
                            Button("Done") { showInsight = false }
                        }
                    }
            }
        }
        .confirmationDialog("Delete this note?", isPresented: Binding(
            get: { noteToDelete != nil },
            set: { if !$0 { noteToDelete = nil } }
        ), titleVisibility: .visible) {
            Button("Delete", role: .destructive) {
                if let noteToDelete { vm.deleteNote(noteToDelete) }
            }
        }
    }

    private var searchField: some View {
        TextField("", text: $query, prompt: Text("Search what you unloaded").foregroundStyle(.white.opacity(0.6)))
            .foregroundStyle(.white)
            .padding(.vertical, 10)
            .padding(.horizontal, 14)
            .skyPanel(cornerRadius: 50, fill: 0.12, border: 0.18)
    }

    private var filters: some View {
        VStack(alignment: .leading, spacing: 6) {
            FlowLayout {
                Chip(title: String(localized: "All"), isOn: mood == nil, ink: ink) { mood = nil }
                ForEach(AnxietyLevelType.skyLevels, id: \.self) { level in
                    Chip(title: level.localizedName, isOn: mood == level, ink: ink) {
                        mood = level
                    } icon: {
                        Image(systemName: level.icon ?? "cloud.fill")
                            .symbolRenderingMode(.monochrome)
                            .imageScale(.small)
                            .frame(height: 16)
                    }
                }
            }
            FlowLayout {
                Chip(title: String(localized: "Handwritten"), isOn: onlyWritten, ink: ink, compact: true) {
                    onlyWritten.toggle()
                } icon: {
                    Image(systemName: "pencil")
                }
                ForEach(tags, id: \.self) { item in
                    Chip(title: "#\(item)", isOn: tag == item, ink: ink, compact: true) {
                        tag = tag == item ? nil : item
                    }
                }
            }
        }
    }

    private func row(_ note: NoteEntity) -> some View {
        Button {
            vm.open(note)
        } label: {
            HStack(spacing: 14) {
                LevelIcon(level: note.level)
                VStack(alignment: .leading, spacing: 2) {
                    Text(note.displayTitle)
                        .font(.rounded(.headline, .semibold))
                        .lineLimit(1)
                    Text(note.summary)
                        .font(.subheadline)
                        .foregroundStyle(.white.opacity(0.78))
                        .lineLimit(1)
                }
                Spacer(minLength: 0)
                Text(note.shortDate)
                    .font(.caption)
                    .foregroundStyle(.white.opacity(0.65))
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 16)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .contextMenu {
            Button {
                vm.togglePin(for: note)
            } label: {
                Label(note.pinned ? "Unpin" : "Pin", systemImage: note.pinned ? "pin.slash" : "pin")
            }
            Button(role: .destructive) {
                noteToDelete = note
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
    }
}
