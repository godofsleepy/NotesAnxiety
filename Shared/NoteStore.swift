//
//  NoteStore.swift
//  NotesAnxiety
//
//  Shared by the app and the widget extension.
//

import Foundation
import SwiftData

/// A journal note. The class and property names match the entity in the
/// app's original Core Data model, so SwiftData opens stores created by
/// earlier versions of the app without losing notes.
@Model
final class NoteEntity {
    var id: UUID?
    var timestamp: Date?
    var title: String?
    var content: String?
    var photoPath: String?
    var audioPath: String?
    var videoPath: String?
    var pinned: Bool = false
    var anxietyLevel: Double = 0
    /// Comma-separated category names.
    var categoryAnxiety: String?

    init(id: UUID = UUID(), timestamp: Date = .now) {
        self.id = id
        self.timestamp = timestamp
    }

    var categories: [String] {
        get { categoryAnxiety?.split(separator: ",").map(String.init) ?? [] }
        set { categoryAnxiety = newValue.joined(separator: ",") }
    }
}

enum NoteStore {
    static let appGroup = "group.com.yellow40.NotesAnxiety"
    private static let storeName = "NotesContainer.sqlite"

    /// Lives in the App Group container so the widget can read it. Falls back
    /// to the app's own Application Support if the group isn't provisioned.
    static var storeURL: URL {
        guard let group = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: appGroup) else {
            return legacyStoreURL
        }
        return group.appending(path: "Library/Application Support", directoryHint: .isDirectory)
            .appending(path: storeName)
    }

    /// Where the Core Data store lived before the App Group existed.
    private static var legacyStoreURL: URL {
        URL.applicationSupportDirectory.appending(path: storeName)
    }

    static var storeExists: Bool {
        FileManager.default.fileExists(atPath: storeURL.path(percentEncoded: false))
    }

    /// Opens the store. Only the app should call this; the widget uses
    /// `storeExists` first so it never creates an empty store that would
    /// block `migrateLegacyStoreIfNeeded`.
    static func makeContainer() throws -> ModelContainer {
        migrateLegacyStoreIfNeeded()
        let storeURL = storeURL
        try FileManager.default.createDirectory(at: storeURL.deletingLastPathComponent(), withIntermediateDirectories: true)
        return try ModelContainer(for: NoteEntity.self, configurations: ModelConfiguration(url: storeURL))
    }

    /// Copies the pre-App-Group store into the shared container once. The
    /// original files are left in place as a backup.
    private static func migrateLegacyStoreIfNeeded() {
        let fileManager = FileManager.default
        let source = legacyStoreURL
        let destination = storeURL
        guard source != destination,
              fileManager.fileExists(atPath: source.path(percentEncoded: false)),
              !fileManager.fileExists(atPath: destination.path(percentEncoded: false)) else { return }

        // The main file is copied last, so its presence marks a finished copy.
        let suffixes = ["-wal", "-shm", ""]
        do {
            try fileManager.createDirectory(at: destination.deletingLastPathComponent(), withIntermediateDirectories: true)
            for suffix in suffixes {
                let from = source.path(percentEncoded: false) + suffix
                let to = destination.path(percentEncoded: false) + suffix
                if fileManager.fileExists(atPath: from) {
                    try? fileManager.removeItem(atPath: to)
                    try fileManager.copyItem(atPath: from, toPath: to)
                }
            }
        } catch {
            print("Failed to move note store into App Group: \(error)")
            for suffix in suffixes {
                try? fileManager.removeItem(atPath: destination.path(percentEncoded: false) + suffix)
            }
        }
    }
}
