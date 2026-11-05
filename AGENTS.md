# AGENTS.md

This file provides guidance to AI coding agents working with code in this repository.

## Project

NotesAnxiety ("Nano3-Notes") is a SwiftUI iOS app for journaling notes tagged with an anxiety level and anxiety categories, plus insight charts. Two targets in `NotesAnxiety.xcodeproj`:

- `NotesAnxiety` — the app (bundle id `com.yellow40.NotesAnxiety`, iOS 18.0 deployment target, Swift 6 language mode).
- `NotesWidgetExtension` — WidgetKit extension in `NotesWidget/`.

No Swift packages, no test targets, no linter config.

## Build

```bash
xcodebuild -project NotesAnxiety.xcodeproj -scheme NotesAnxiety -destination 'platform=iOS Simulator,name=iPhone 16 Pro,OS=18.3.1' build
```

Without `OS=`, xcodebuild looks for the device on the newest installed runtime, where iPhone 16 Pro may not exist; `xcrun simctl list devices available` shows which name/OS pairs are installed.

Widget scheme: `NotesWidgetExtension`. The app uses HealthKit and Journaling Suggestions entitlements (`NotesAnxiety/NotesAnxiety.entitlements`); `JournalingSuggestions` isn't in the simulator SDK, so its picker is wrapped in `#if canImport(JournalingSuggestions)` and only appears on device.

## Xcode project uses explicit file references

The project does **not** use folder-synchronized groups — a `.swift` file is compiled only if it is listed in `project.pbxproj`. New files must be added to the target. `Shared/NoteStore.swift` and `Models/AnxietyLevelType.swift` are members of both the app and widget targets.

## Architecture

MVVM with a single shared view model, using Observation and SwiftData:

- `NotesAnxietyApp` holds one `@Observable @MainActor NotesViewModel` (built by `Utils/DependencyInjection`, which owns the `ModelContainer` and a lazy `LocalDataService`) in `@State` and injects it with `.environment(_:)`. Views read it via `@Environment(NotesViewModel.self)`.
- `ContentView` draws `SkyBackground` (weather for `vm.skyLevel`) behind two custom tabs: `HomeView` (Sky) and `JournalView`. The UI follows the "Notes Anxiety Mobile" Claude Design file: always dark, with the palette in `AnxietyLevelType.sky` and shared controls in `Views/Components/SkyComponents.swift`.
- Check-ins run through `vm.flow` (`CheckInFlow`): idle → before → talking or writing → after → done. It lives on the view model so it survives switching tabs, and `saveCheckIn()` writes the note. There is no Claude integration: "talking" only opens claude.ai, and that check-in is saved with no text.
- `JournalView` filters locally (mood, tag, handwritten, search). `NoteDetailView` reads and edits a note in place with an explicit save (`vm.saveEdit`). Pin and delete are in the row's context menu; `InsightView` opens as a sheet from the Journal title row.
- `CloudScene` renders `cloud-rain.scn`. Rain nodes are `Plane001…`, with their meshes on child nodes; bolts are `lightning1/2`, whose opacity is driven by the model's own animation, so they're hidden with `isHidden`.
- Persistence (`Shared/NoteStore.swift`): SwiftData `@Model final class NoteEntity`. Its class and property names deliberately match the original Core Data entity so stores from older builds open unchanged — don't rename them without a migration plan.
  - The store lives in the App Group `group.com.yellow40.NotesAnxiety` (`NoteStore.storeURL`) so the widget can read it. On first launch `NoteStore.makeContainer()` copies the pre-App-Group store from the app's own Application Support (the old copy is left as a backup).
  - `Data/LocalDataService` is `@MainActor` and uses the container's `mainContext`; every save calls `WidgetCenter.shared.reloadAllTimelines()`.
  - `categoryAnxiety` is stored as a comma-joined `String`; use `NoteEntity.categories` for the array form.
  - `anxietyLevel` is a `Double` 0–4 (the level before unloading, 0 means no check-in); `anxietyLevelAfter` is the optional level afterwards, nil on older notes; `Models/AnxietyLevelType` maps it to minimal/mild/moderate/severe (and to color/image assets like `SystemMild`, `CardsSevere`).
  - Media (photo/audio/video) are stored as absolute file path strings into Documents. Images are written once when picked, not on every save.
- `Utils/NotificationManager` (`@MainActor`) requests permission and schedules the daily reminder at launch under a fixed identifier.

## Widget

`NotesWidget/NotesWidgetBundle.swift` reads the shared store read-only and shows the latest notes plus a 7-day check-in count. It checks `NoteStore.storeExists` first and never creates the store, because the app's legacy-store migration only runs when no store exists in the App Group yet.

## Localization / assets

Strings live in `NotesAnxiety/Localizable.xcstrings` (source language `en`). Named colors (`BackgroundPrimary`, `LabelPrimary`, `System*`, `Cards*`, …) are duplicated in both the app and widget asset catalogs — update both when changing a color.
