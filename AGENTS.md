# AGENTS.md

This file provides guidance to AI coding agents working with code in this repository.

## Project

NotesAnxiety ("Nano3-Notes") is a SwiftUI iOS app for journaling notes tagged with an anxiety level and anxiety categories, plus insight charts. Two targets in `NotesAnxiety.xcodeproj`:

- `NotesAnxiety` — the app (bundle id `com.yellow40.NotesAnxiety`, iOS 17.x deployment target, Swift 5).
- `NotesWidgetExtension` — WidgetKit extension in `NotesWidget/`.

No Swift packages, no test targets, no linter config.

## Build

```bash
xcodebuild -project NotesAnxiety.xcodeproj -scheme NotesAnxiety -destination 'platform=iOS Simulator,name=iPhone 16' build
```

Widget scheme: `NotesWidgetExtension`. The app uses HealthKit and Journaling Suggestions entitlements (`NotesAnxiety/NotesAnxiety.entitlements`); `JournalingSuggestionsPicker` only works on a real device.

## Xcode project uses explicit file references

The project does **not** use folder-synchronized groups — a `.swift` file is compiled only if it is listed in `project.pbxproj`. New files must be added to the target. Several files on disk are **not** in any target and are dead/scratch copies:

- `NotesAnxiety/ViewModels/Views/**` — an older duplicate of the views tree.
- In `NotesAnxiety/Views/Components/`: `AnxietyCategoryComponent`, `AnxietyCategoryView`, `AnxietyLevelComponent`, `AnxietyStatusComponent`, `AnxietyTrackerView` (the compiled anxiety components are `CategoryComponent`/`CategoryView`, `StatusComponent`/`StatusView`, `LogComponent`/`LogView`).
- `TextFormatterView.swift` at repo root.

Before editing a view, confirm it's the compiled copy (`grep <FileName>.swift NotesAnxiety.xcodeproj/project.pbxproj`).

## Architecture

MVVM with a single shared view model:

- `NotesAnxietyApp` injects one `NotesViewModel` (built by `Utils/DependencyInjection`, a singleton that owns a lazy `LocalDataService`) as an `@EnvironmentObject`. Views read it via `@EnvironmentObject`.
- `ContentView` is a `NavigationSplitView`: sidebar `HistoryNotesView` (note list, search, pin, delete) and detail `EditNotesView` (editor, anxiety level/category, media, journaling suggestions). `InsightView` / `AnalyticsView` / `ChartView` render anxiety trends. The view model's `preferredColumn` drives which split column is shown on compact widths.
- Editing is autosave: `EditNotesView` calls `NotesViewModel.performUpdate(...)`, which pushes a `TemporaryNoteModel` into a Combine `PassthroughSubject` debounced 1s, then `updateNote` creates the note if `selectedNote` is nil, persists, sets `updateProgressState` (`ProgressState`), and refetches `notes`.
- Persistence: `Data/LocalDataService` (protocol + `LocalDataServiceImpl`) wraps an `NSPersistentContainer` named `NotesContainer` (`Data/CoreData Container/NotesContainer.xcdatamodeld`). Single entity `NoteEntity` with Xcode-generated class (`codeGenerationType="class"`) — no hand-written NSManagedObject subclass. All work runs on `viewContext.performAndWait`.
  - `categoryAnxiety` is stored as a comma-joined `String`; `TemporaryNoteModel.categoryAnxiety` is `[String]`.
  - `anxietyLevel` is a `Double` 0–4; `Models/AnxietyLevelType` maps it to minimal/mild/moderate/severe (and to color/image assets like `SystemMild`, `CardsSevere`).
  - Media (photo/audio/video) are stored as file path strings, not blobs.
- `Utils/NotificationManager` requests permission and schedules a daily reminder at app launch.
- `Data/HealthService` exists but isn't wired into the UI.

## Widget

`NotesWidget/PersistenceController` is a separate Core Data stack that is not functional yet: it opens a container named `"YourModelName"` and there is no App Group, so the widget cannot read the app's store. The timeline provider currently returns empty entries.

## Localization / assets

Strings live in `NotesAnxiety/Localizable.xcstrings` (source language `en`). Named colors (`BackgroundPrimary`, `LabelPrimary`, `System*`, `Cards*`, …) are duplicated in both the app and widget asset catalogs — update both when changing a color.
