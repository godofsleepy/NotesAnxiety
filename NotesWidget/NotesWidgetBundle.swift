//
//  NotesWidgetBundle.swift
//  NotesWidget
//
//  Created by Rifat Khadafy on 16/07/24.
//

import WidgetKit
import SwiftUI
import CoreData

@main
struct NotesWidgets: WidgetBundle {
    @WidgetBundleBuilder
    var body: some Widget {
        NotesWidget()
    }
}

struct Provider: TimelineProvider {
    func placeholder(in context: Context) -> SimpleEntry {
        SimpleEntry(date: Date(), notes: [])
    }

    func getSnapshot(in context: Context, completion: @escaping (SimpleEntry) -> ()) {
        let entry = SimpleEntry(date: Date(), notes: [])
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<SimpleEntry>) -> ()) {
        let entry = SimpleEntry(date: Date(), notes: [])
        
        // Update policy depending on your needs
        let timeline = Timeline(entries: [entry], policy: .atEnd)
        completion(timeline)
    }
}

struct SimpleEntry: TimelineEntry {
    let date: Date
    let notes: [NoteEntity]
}

struct NotesWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        VStack {
            HStack {
                Text("Feeling Anxious Today?")
                    .font(.system(size: 21))
                    .fontWeight(.bold)
                    .foregroundColor(.black)
                    .padding()
                Spacer()
            }
            Spacer()
        }
        .containerBackground(for: .widget) {  // Apply containerBackground for widget
            LinearGradient(
                gradient: Gradient(colors: [Color.white, Color.indigo]),
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        }
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

