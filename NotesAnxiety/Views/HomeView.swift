//
//  HomeView.swift
//  NotesAnxiety
//
//  The Sky tab: current weather, and the before → unload → after check-in.
//

import SwiftUI

struct HomeView: View {
    @Environment(NotesViewModel.self) private var vm
    @Environment(\.openURL) private var openURL
    @State private var openedClaude = false

    private static let claudeURL = URL(string: "https://claude.ai")!

    init() {
        // SwiftUI's Slider has no modifier for the unfilled track.
        UISlider.appearance().maximumTrackTintColor = .clear
    }

    private struct Step {
        var eyebrow: String
        var level: AnxietyLevelType
        var title: String
        var line: String
        var primaryLabel: String
        var primary: () -> Void
        var secondaryLabel: String?
        var secondary: (() -> Void)?
    }

    private var ink: Color { vm.skyLevel.sky.ink }
    private var flow: CheckInFlow { vm.flow }

    var body: some View {
        @Bindable var vm = vm
        let step = step
        GeometryReader { geometry in
            ScrollViewReader { scroller in
            ScrollView {
                VStack(spacing: 16) {
                    BrandHeader()
                        .id("top")
                    hero(step)
                    if flow.phase == .writing {
                        writingFields
                    }
                    if flow.phase == .before || flow.phase == .after {
                        slider
                    }
                    actions(step)
                    if flow.phase == .idle {
                        weekCard
                        lastCard
                    } else {
                        Spacer(minLength: 0)
                    }
                    CrisisFooter()
                }
                .frame(maxWidth: 560)
                .frame(maxWidth: .infinity, minHeight: geometry.size.height)
                .padding(.horizontal, 16)
            }
            .scrollIndicators(.hidden)
            .scrollDismissesKeyboard(.interactively)
            .onChange(of: flow.phase) {
                scroller.scrollTo("top", anchor: .top)
            }
            }
        }
    }

    private func hero(_ step: Step) -> some View {
        VStack(spacing: 16) {
            Text(step.eyebrow)
                .font(.rounded(.subheadline))
                .foregroundStyle(.white.opacity(0.78))
                .padding(.top, 16)
            CloudHero(
                level: step.level,
                size: flow.phase == .writing ? 126 : 210,
                motion: flow.phase == .talking ? .breathe : .float
            )
            .animation(.easeInOut(duration: 0.4), value: flow.phase)
            VStack(spacing: 6) {
                Text(step.title)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                Text(step.line)
                    .foregroundStyle(.white.opacity(0.85))
                    .frame(maxWidth: 400)
            }
            .multilineTextAlignment(.center)
        }
    }

    private var slider: some View {
        @Bindable var vm = vm
        return VStack(spacing: 6) {
            Slider(value: $vm.flow.value, in: 1...4)
                .tint(.clear)
                .padding(4)
                .background(.white.opacity(0.16), in: Capsule())
                .overlay(Capsule().strokeBorder(.white.opacity(0.2)))
                .accessibilityLabel("How heavy it feels")
                .accessibilityValue(AnxietyLevelType.sky(vm.flow.value).localizedName)
            HStack {
                Text("Light")
                Spacer()
                Text("Heavy")
            }
            .font(.caption)
            .foregroundStyle(.white.opacity(0.7))
        }
        .frame(maxWidth: 340)
        .padding(.top, 10)
    }

    private var writingFields: some View {
        @Bindable var vm = vm
        return VStack(alignment: .leading, spacing: 10) {
            SkyTextField(placeholder: String(localized: "Give it a title (optional)"), text: $vm.flow.title)
            SkyTextEditor(placeholder: String(localized: "What's on your mind? No one else reads this."), text: $vm.flow.body)
            AttachmentBar(photoPath: $vm.flow.photoPath, audioPath: $vm.flow.audioPath)
            Text("Categories")
                .font(.rounded(.footnote))
                .foregroundStyle(.white.opacity(0.78))
            TagPicker(selection: $vm.flow.tags, tags: NoteEntity.suggestedTags, ink: ink)
        }
    }

    private func actions(_ step: Step) -> some View {
        VStack(spacing: 6) {
            PrimaryButton(title: step.primaryLabel, ink: ink, action: step.primary)
            if let label = step.secondaryLabel, let action = step.secondary {
                TextActionButton(title: label, action: action)
            }
            if flow.phase == .talking {
                OutlineButton(title: String(localized: "Write it down instead"), systemImage: "pencil") {
                    vm.flow.phase = .writing
                }
            }
        }
        .frame(maxWidth: 340)
        .padding(.top, 10)
    }

    private var weekCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("This week's weather")
                .font(.rounded(.footnote))
                .foregroundStyle(.white.opacity(0.78))
            HStack(spacing: 4) {
                ForEach(vm.weekWeather) { day in
                    VStack(spacing: 6) {
                        Group {
                            if let level = day.level {
                                LevelIcon(level: level, size: 22)
                            } else {
                                Circle()
                                    .fill(.white.opacity(0.35))
                                    .frame(width: 6, height: 6)
                            }
                        }
                        .frame(height: 34)
                        Text(day.date, format: .dateTime.weekday(.narrow))
                            .font(.caption)
                            .foregroundStyle(.white.opacity(0.72))
                    }
                    .frame(maxWidth: .infinity)
                    .accessibilityElement(children: .ignore)
                    .accessibilityLabel(Text(day.date, format: .dateTime.weekday(.wide)))
                    .accessibilityValue(day.level?.localizedName ?? String(localized: "No session"))
                }
            }
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .skyPanel()
        .padding(.top, 16)
    }

    @ViewBuilder
    private var lastCard: some View {
        if let last = vm.notes.first {
            Button {
                vm.open(last)
            } label: {
                HStack(spacing: 14) {
                    LevelIcon(level: last.level, size: 30)
                    VStack(alignment: .leading, spacing: 2) {
                        Text("Last time · \(last.shortDate.lowercased())")
                            .font(.rounded(.footnote))
                            .foregroundStyle(.white.opacity(0.72))
                        Text(last.displayTitle)
                            .font(.rounded(.headline, .semibold))
                            .lineLimit(1)
                    }
                    Spacer(minLength: 0)
                    Image(systemName: "chevron.right")
                        .foregroundStyle(.white.opacity(0.6))
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .skyPanel()
            }
            .buttonStyle(.plain)
        }
    }

    private var step: Step {
        let value = AnxietyLevelType.sky(flow.value)
        let before = AnxietyLevelType.sky(flow.before ?? 2)
        let after = AnxietyLevelType.sky(flow.after ?? 2)
        switch flow.phase {
        case .idle:
            let current = vm.currentLevel
            return Step(
                eyebrow: String(localized: "Your sky lately"),
                level: current ?? .minimal,
                title: current?.localizedName ?? String(localized: "Clear skies"),
                line: Self.skyLine(for: current),
                primaryLabel: String(localized: "Unload"),
                primary: { vm.flow = CheckInFlow(phase: .before, value: 1) }
            )
        case .before:
            return Step(
                eyebrow: String(localized: "Before you talk"),
                level: value,
                title: String(localized: "How heavy does it feel?"),
                line: String(localized: "Slide until the sky looks like your head right now. \(value.localizedName)."),
                primaryLabel: String(localized: "Continue"),
                primary: {
                    openedClaude = false
                    vm.flow.before = flow.value
                    vm.flow.phase = .talking
                },
                secondaryLabel: String(localized: "Not now"),
                secondary: { vm.flow = CheckInFlow() }
            )
        case .talking:
            return Step(
                eyebrow: String(localized: "Logged · \(before.localizedName)"),
                level: before,
                title: String(localized: "Talk it out with Claude"),
                line: String(localized: "Open Claude and say whatever is there. Come back when you're done, and log how it feels."),
                primaryLabel: openedClaude ? String(localized: "I'm back") : String(localized: "Open Claude"),
                primary: {
                    if openedClaude {
                        vm.flow.value = flow.before ?? 2
                        vm.flow.phase = .after
                    } else {
                        openedClaude = true
                        openURL(Self.claudeURL)
                    }
                },
                secondaryLabel: String(localized: "Cancel"),
                secondary: { vm.flow = CheckInFlow() }
            )
        case .writing:
            let hasDraft = !flow.body.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
            return Step(
                eyebrow: String(localized: "Logged · \(before.localizedName)"),
                level: before,
                title: String(localized: "Write it down"),
                line: String(localized: "Just for you. Nothing here is sent to Claude."),
                primaryLabel: hasDraft ? String(localized: "Continue") : String(localized: "Write something first"),
                primary: {
                    guard hasDraft else { return }
                    vm.flow.value = flow.before ?? 2
                    vm.flow.isWritten = true
                    vm.flow.phase = .after
                },
                secondaryLabel: String(localized: "Talk to Claude instead"),
                secondary: {
                    vm.flow.isWritten = false
                    vm.flow.phase = .talking
                }
            )
        case .after:
            return Step(
                eyebrow: flow.isWritten ? String(localized: "After writing") : String(localized: "After you talked"),
                level: value,
                title: String(localized: "And now?"),
                line: String(localized: "Move it if anything changed. \(value.localizedName)."),
                primaryLabel: String(localized: "Save"),
                primary: { vm.saveCheckIn() },
                secondaryLabel: flow.isWritten ? String(localized: "Edit note") : nil,
                secondary: flow.isWritten ? { vm.flow.phase = .writing } : nil
            )
        case .done:
            let change = (flow.before ?? 2) - (flow.after ?? 2)
            return Step(
                eyebrow: "\(before.localizedName) → \(after.localizedName)",
                level: after,
                title: change > 0.3 ? String(localized: "Lighter than before")
                    : change < -0.3 ? String(localized: "Heavier tonight. That happens.")
                    : String(localized: "About the same. Still worth it."),
                line: String(localized: "Saved to your journal."),
                primaryLabel: String(localized: "Done"),
                primary: { vm.flow = CheckInFlow() },
                secondaryLabel: String(localized: "Read entry"),
                secondary: {
                    if let note = flow.savedNote { vm.open(note) }
                }
            )
        }
    }

    private static func skyLine(for level: AnxietyLevelType?) -> String {
        switch level {
        case .minimal: String(localized: "Clear skies. Your last few sessions felt light.")
        case .mild: String(localized: "A little drizzle. Mostly manageable lately.")
        case .moderate: String(localized: "Steady rain. A lot has been on your mind.")
        case .severe: String(localized: "Stormy. Be gentle with yourself tonight.")
        case .empty, nil: String(localized: "Nothing logged yet. Unload whenever you're ready.")
        }
    }
}
