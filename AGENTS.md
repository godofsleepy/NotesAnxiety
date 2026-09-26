# AGENTS.md

This file provides guidance to AI coding agents working with code in this repository.

## Project

NotesAnxiety ("Nano3-Notes") is a SwiftUI iOS app for journaling notes tagged with an anxiety level and anxiety categories, plus insight charts. Two targets in `NotesAnxiety.xcodeproj`:

- `NotesAnxiety` — the app (bundle id `com.yellow40.NotesAnxiety`, iOS 18.0 deployment target, Swift 6 language mode).
- `NotesWidgetExtension` — WidgetKit extension in `NotesWidget/`.

No Swift packages, no test targets, no linter config.

## Build

```bash
xcodebuild -project NotesAnxiety.xcodeproj -scheme NotesAnxiety -destination 'platform=iOS Simulator,name=iPhone 16 Pro' build
```

Widget scheme: `NotesWidgetExtension`. The app uses HealthKit and Journaling Suggestions entitlements (`NotesAnxiety/NotesAnxiety.entitlements`); `JournalingSuggestions` isn't in the simulator SDK, so its picker is wrapped in `#if canImport(JournalingSuggestions)` and only appears on device.

## Xcode project uses explicit file references

The project does **not** use folder-synchronized groups — a `.swift` file is compiled only if it is listed in `project.pbxproj`. New files must be added to the target. `Shared/NoteStore.swift` and `Models/AnxietyLevelType.swift` are members of both the app and widget targets.

## Architecture

MVVM with a single shared view model, using Observation and SwiftData:

- `NotesAnxietyApp` holds one `@Observable @MainActor NotesViewModel` (built by `Utils/DependencyInjection`, which owns the `ModelContainer` and a lazy `LocalDataService`) in `@State` and injects it with `.environment(_:)`. Views read it via `@Environment(NotesViewModel.self)`.
- `ContentView` is a `NavigationSplitView`: sidebar `HistoryNotesView` (note list, search, pin, delete) and detail `EditNotesView` (editor, anxiety level/category, media, journaling suggestions). `InsightView` / `AnalyticsView` / `ChartView` render anxiety trends. The view model's `preferredColumn` is bound to the split view's compact column.
- Editing is autosave: `EditNotesView` calls `NotesViewModel.performUpdate(...)`, which skips no-op edits, then schedules a 1s-debounced `Task` (cancelled by the next edit to the same note). The target note is captured at edit time; if there is none, a note is created and becomes `selectedNote`.
- Anxiety check-ins flow `LogView` → `CategoryView`, which sets `vm.temporaryAnxiety`; `EditNotesView` picks it up with `onChange` and saves.
- Persistence (`Shared/NoteStore.swift`): SwiftData `@Model final class NoteEntity`. Its class and property names deliberately match the original Core Data entity so stores from older builds open unchanged — don't rename them without a migration plan.
  - The store lives in the App Group `group.com.yellow40.NotesAnxiety` (`NoteStore.storeURL`) so the widget can read it. On first launch `NoteStore.makeContainer()` copies the pre-App-Group store from the app's own Application Support (the old copy is left as a backup).
  - `Data/LocalDataService` is `@MainActor` and uses the container's `mainContext`; every save calls `WidgetCenter.shared.reloadAllTimelines()`.
  - `categoryAnxiety` is stored as a comma-joined `String`; use `NoteEntity.categories` for the array form.
  - `anxietyLevel` is a `Double` 0–4; `Models/AnxietyLevelType` maps it to minimal/mild/moderate/severe (and to color/image assets like `SystemMild`, `CardsSevere`).
  - Media (photo/audio/video) are stored as absolute file path strings into Documents. Images are written once when picked, not on every autosave.
- `Utils/NotificationManager` (`@MainActor`) requests permission and schedules the daily reminder at launch under a fixed identifier.

## Widget

`NotesWidget/NotesWidgetBundle.swift` reads the shared store read-only and shows the latest notes plus a 7-day check-in count. It checks `NoteStore.storeExists` first and never creates the store, because the app's legacy-store migration only runs when no store exists in the App Group yet.

## Localization / assets

Strings live in `NotesAnxiety/Localizable.xcstrings` (source language `en`). Named colors (`BackgroundPrimary`, `LabelPrimary`, `System*`, `Cards*`, …) are duplicated in both the app and widget asset catalogs — update both when changing a color.
