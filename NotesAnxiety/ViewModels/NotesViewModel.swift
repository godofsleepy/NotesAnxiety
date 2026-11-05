//
//  NotesViewModel.swift
//  Anxiety Notes
//
//  Created by Filbert Chai on 10/07/24.
//

import Foundation
import SwiftUI
import Observation

enum AppTab {
    case sky, journal
}

/// In-progress check-in. Lives on the view model so it survives switching tabs.
struct CheckInFlow {
    enum Phase {
        case idle, before, talking, writing, after, done
    }

    var phase = Phase.idle
    var value = 2.0
    var before: Double?
    var after: Double?
    var isWritten = false
    var title = ""
    var body = ""
    var tags: [String] = []
    var photoPath: String?
    var audioPath: String?
    var savedNote: NoteEntity?
}

struct DayWeather: Identifiable {
    let date: Date
    let level: AnxietyLevelType?
    var id: Date { date }
}

@Observable
@MainActor
final class NotesViewModel {

    let localDataService: LocalDataService
    var notes: [NoteEntity] = []
    var tab = AppTab.sky
    var selectedNote: NoteEntity?
    var flow = CheckInFlow()

    init(localDataService: LocalDataService) {
        self.localDataService = localDataService
    }

    /// Weather from the three latest check-ins; nil until there is one.
    var currentLevel: AnxietyLevelType? {
        let recent = notes.filter { $0.level != nil }.prefix(3)
        guard !recent.isEmpty else { return nil }
        return .sky(recent.map(\.settledValue).reduce(0, +) / Double(recent.count))
    }

    /// The level the background shows right now.
    var skyLevel: AnxietyLevelType {
        if tab == .sky {
            switch flow.phase {
            case .before, .after: return .sky(flow.value)
            case .done: return .sky(flow.after ?? 2)
            default: break
            }
        }
        return currentLevel ?? .minimal
    }

    var weekWeather: [DayWeather] {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: .now)
        return (0..<7).reversed().map { offset in
            let day = calendar.date(byAdding: .day, value: -offset, to: today)!
            let values = notes
                .filter { $0.level != nil && calendar.isDate($0.timestamp ?? .distantPast, inSameDayAs: day) }
                .map(\.settledValue)
            let level = values.isEmpty ? nil : AnxietyLevelType.sky(values.reduce(0, +) / Double(values.count))
            return DayWeather(date: day, level: level)
        }
    }

    func open(_ note: NoteEntity) {
        selectedNote = note
        tab = .journal
    }

    func togglePin(for note: NoteEntity) {
        localDataService.togglePin(for: note)
        fetchNotes()
    }

    func saveCheckIn() {
        let body = flow.isWritten ? flow.body.trimmingCharacters(in: .whitespacesAndNewlines) : ""
        let typedTitle = flow.title.trimmingCharacters(in: .whitespacesAndNewlines)
        let title: String
        if !flow.isWritten {
            title = String(localized: "Talk with Claude")
        } else if typedTitle.isEmpty {
            title = body.split(whereSeparator: \.isWhitespace).prefix(5).joined(separator: " ")
        } else {
            title = typedTitle
        }

        let note = localDataService.createNote()
        localDataService.updateNote(note, temporaryNote: TemporaryNoteModel(
            title: title,
            content: body,
            photoPath: flow.isWritten ? flow.photoPath : nil,
            audiotPath: flow.isWritten ? flow.audioPath : nil,
            anxietyLevel: flow.before ?? flow.value,
            anxietyLevelAfter: flow.value,
            categoryAnxiety: flow.isWritten ? flow.tags : []
        ))
        fetchNotes()
        flow = CheckInFlow(phase: .done, before: flow.before, after: flow.value, savedNote: note)
    }

    func saveEdit(of note: NoteEntity, title: String, content: String, tags: [String], photoPath: String?, audioPath: String?) {
        localDataService.updateNote(note, temporaryNote: TemporaryNoteModel(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            content: content.trimmingCharacters(in: .whitespacesAndNewlines),
            photoPath: photoPath,
            videoPath: note.videoPath,
            audiotPath: audioPath,
            anxietyLevel: note.anxietyLevel,
            anxietyLevelAfter: note.anxietyLevelAfter,
            categoryAnxiety: tags,
            pinned: note.pinned
        ))
        fetchNotes()
    }

    func fetchNotes() {
        do {
            notes = try localDataService.fetchNotes(searchText: "")
        } catch {
            print("Error fetching notes: \(error)")
        }
    }

    func deleteNote(_ note: NoteEntity) {
        if selectedNote == note {
            selectedNote = nil
        }
        if flow.savedNote == note {
            flow.savedNote = nil
        }
        localDataService.deleteNote(note)
        fetchNotes()
    }
}

extension AnxietyLevelType {
    /// Like `from(_:)`, but always returns a real level.
    static func sky(_ value: Double) -> AnxietyLevelType {
        from(min(max(value, 1), 4))
    }
}

extension NoteEntity {
    static let suggestedTags = ["Work", "Sleep", "Health", "Money", "Family", "Friends", "Self-Care"]

    /// The check-in level, or nil for a note logged without one.
    var level: AnxietyLevelType? {
        anxietyLevel >= 1 ? .sky(anxietyLevel) : nil
    }

    /// How it felt afterwards. Notes from before the after-slider only have
    /// the one level.
    var settledValue: Double {
        anxietyLevelAfter ?? anxietyLevel
    }

    var settledLevel: AnxietyLevelType? {
        level == nil ? nil : .sky(settledValue)
    }

    var isWritten: Bool {
        content?.isEmpty == false
    }

    var displayTitle: String {
        if let title, !title.isEmpty { return title }
        return String(localized: "New Note")
    }

    var summary: String {
        if let content, !content.isEmpty { return content }
        if !categories.isEmpty { return categories.joined(separator: ", ") }
        return level == nil ? String(localized: "No text") : String(localized: "Check-in")
    }

    var searchText: String {
        ([title ?? "", content ?? ""] + categories).joined(separator: " ")
    }

    var shortDate: String {
        let date = timestamp ?? .now
        let calendar = Calendar.current
        if calendar.isDateInToday(date) { return String(localized: "Today") }
        if calendar.isDateInYesterday(date) { return String(localized: "Yesterday") }
        return date.formatted(.dateTime.day().month(.abbreviated))
    }
}
