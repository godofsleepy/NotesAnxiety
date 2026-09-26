//
//  NotesWidgetBundle.swift
//  NotesWidget
//
//  Created by Rifat Khadafy on 16/07/24.
//

import WidgetKit
import SwiftUI
import SwiftData

@main
struct NotesWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        NotesWidget()
    }
}

/// A value copy of a note, so entries don't hold SwiftData models.
struct NoteSnapshot: Hashable {
    let title: String
    let date: Date
    let anxietyLevel: Double
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let notes: [NoteSnapshot]
    let checkInsThisWeek: Int
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: .now, notes: [NoteSnapshot(title: "Today's note", date: .now, anxietyLevel: 2)], checkInsThisWeek: 3)
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        completion(context.isPreview ? placeholder(in: context) : loadEntry())
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        // The app reloads timelines after every save; the daily refresh keeps
        // "this week" counts current.
        let tomorrow = Calendar.current.startOfDay(for: .now).addingTimeInterval(24 * 60 * 60)
        completion(Timeline(entries: [loadEntry()], policy: .after(tomorrow)))
    }

    private func loadEntry() -> SimpleEntry {
        // Don't create the store from the widget: the app copies its legacy
        // store into the App Group only when none exists there yet.
        guard NoteStore.storeExists,
              let container = try? ModelContainer(for: NoteEntity.self, configurations: ModelConfiguration(url: NoteStore.storeURL, allowsSave: false)) else {
            return SimpleEntry(date: .now, notes: [], checkInsThisWeek: 0)
        }
        let context = ModelContext(container)
        let allNotes = (try? context.fetch(FetchDescriptor<NoteEntity>(sortBy: [SortDescriptor(\.timestamp, order: .reverse)]))) ?? []
        let notes = allNotes.prefix(3)

        let weekStart = Calendar.current.date(byAdding: .day, value: -7, to: .now) ?? .now
        let checkIns = allNotes.filter { $0.anxietyLevel >= 1 && ($0.timestamp ?? .distantPast) >= weekStart }.count

        return SimpleEntry(
            date: .now,
            notes: notes.map {
                NoteSnapshot(title: $0.title?.isEmpty == false ? $0.title! : "New Note", date: $0.timestamp ?? .now, anxietyLevel: $0.anxietyLevel)
            },
            checkInsThisWeek: checkIns
        )
    }
}

struct NotesWidgetEntryView: View {
    @Environment(\.widgetFamily) private var family
    var entry: Provider.Entry

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Feeling Anxious Today?")
                .font(family == .systemSmall ? .headline : .title3)
                .fontWeight(.bold)
                .foregroundColor(.labelPrimary)

            if entry.notes.isEmpty {
                Text("Write down what you're feeling.")
                    .font(.subheadline)
                    .foregroundColor(.labelSecondary)
            } else {
                ForEach(entry.notes.prefix(noteLimit), id: \.self) { note in
                    HStack(spacing: 6) {
                        if let symbol = AnxietyLevelType.image(anxiety: note.anxietyLevel), note.anxietyLevel >= 1 {
                            Image(systemName: symbol)
                                .foregroundColor(AnxietyLevelType.color(anxiety: note.anxietyLevel))
                        }
                        Text(note.title)
                            .font(.subheadline)
                            .lineLimit(1)
                        Spacer(minLength: 0)
                    }
                }
            }

            Spacer(minLength: 0)

            if family != .systemSmall {
                Text("\(entry.checkInsThisWeek) check-ins in the last 7 days")
                    .font(.caption)
                    .foregroundColor(.labelSecondary)
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .containerBackground(for: .widget) {
            LinearGradient(
                gradient: Gradient(colors: [Color.backgroundPrimary, Color.systemSevere]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
    }

    private var noteLimit: Int {
        family == .systemSmall ? 1 : 3
    }
}

struct NotesWidget: Widget {
    let kind: String = "NotesWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            NotesWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("Notes Widget")
        .description("Display recent notes.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}
