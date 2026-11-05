//
//  SkyBackground.swift
//  NotesAnxiety
//
//  The full-screen weather behind every screen. Its palette and timings come
//  from the "Notes Anxiety Mobile" design.
//

import SwiftUI

extension Color {
    /// Builds a color from CSS `oklch()` values, so the palette reads the same
    /// as the design file. `hue` is in degrees.
    init(oklch lightness: Double, _ chroma: Double, _ hue: Double) {
        let a = chroma * cos(hue * .pi / 180)
        let b = chroma * sin(hue * .pi / 180)
        let l = pow(lightness + 0.3963377774 * a + 0.2158037573 * b, 3)
        let m = pow(lightness - 0.1055613458 * a - 0.0638541728 * b, 3)
        let s = pow(lightness - 0.0894841775 * a - 1.2914855480 * b, 3)
        self.init(
            .sRGBLinear,
            red: min(max(4.0767416621 * l - 3.3077115913 * m + 0.2309699292 * s, 0), 1),
            green: min(max(-1.2684380046 * l + 2.6097574011 * m - 0.3413193965 * s, 0), 1),
            blue: min(max(-0.0041960863 * l - 0.7034186147 * m + 1.7076147010 * s, 0), 1)
        )
    }
}

struct SkyPalette {
    let core: Color
    let mid: Color
    let edge: Color
    /// Text on white controls placed over this sky.
    let ink: Color
    let drops: Int
}

extension AnxietyLevelType {
    static let skyLevels: [AnxietyLevelType] = [.minimal, .mild, .moderate, .severe]

    var sky: SkyPalette {
        switch self {
        case .minimal, .empty:
            SkyPalette(core: Color(oklch: 0.70, 0.11, 212), mid: Color(oklch: 0.56, 0.10, 222), edge: Color(oklch: 0.40, 0.07, 232), ink: Color(oklch: 0.42, 0.09, 225), drops: 0)
        case .mild:
            SkyPalette(core: Color(oklch: 0.62, 0.12, 228), mid: Color(oklch: 0.48, 0.09, 232), edge: Color(oklch: 0.33, 0.05, 236), ink: Color(oklch: 0.40, 0.09, 232), drops: 14)
        case .moderate:
            SkyPalette(core: Color(oklch: 0.52, 0.12, 242), mid: Color(oklch: 0.38, 0.08, 246), edge: Color(oklch: 0.25, 0.04, 250), ink: Color(oklch: 0.36, 0.09, 245), drops: 26)
        case .severe:
            SkyPalette(core: Color(oklch: 0.42, 0.10, 252), mid: Color(oklch: 0.29, 0.06, 256), edge: Color(oklch: 0.17, 0.03, 260), ink: Color(oklch: 0.30, 0.08, 255), drops: 38)
        }
    }

    var localizedName: String {
        String(localized: String.LocalizationValue(rawValue))
    }
}

struct SkyBackground: View {
    let level: AnxietyLevelType

    private var driftOpacity: Double {
        switch level {
        case .minimal, .empty: 1
        case .mild: 0.6
        case .moderate, .severe: 0
        }
    }

    var body: some View {
        ZStack {
            ForEach(AnxietyLevelType.skyLevels, id: \.self) { skyLevel in
                SkyGradient(palette: skyLevel.sky)
                    .opacity(skyLevel == level ? 1 : 0)
            }
            SkyWeather(
                drops: Double(level.sky.drops),
                drift: driftOpacity,
                flash: level == .severe ? 1 : 0
            )
        }
        .animation(.easeInOut(duration: 1.4), value: level)
        .ignoresSafeArea()
        .allowsHitTesting(false)
        .accessibilityHidden(true)
    }
}

/// `radial-gradient(120% 85% at 50% 32%, core, mid 48%, edge)`.
private struct SkyGradient: View {
    let palette: SkyPalette

    var body: some View {
        Canvas { context, size in
            let gradient = Gradient(stops: [
                .init(color: palette.core, location: 0),
                .init(color: palette.mid, location: 0.48),
                .init(color: palette.edge, location: 1),
            ])
            context.translateBy(x: size.width * 0.5, y: size.height * 0.32)
            context.scaleBy(x: size.width * 1.2, y: size.height * 0.85)
            context.fill(
                Path(CGRect(x: -3, y: -3, width: 6, height: 6)),
                with: .radialGradient(gradient, center: .zero, startRadius: 0, endRadius: 1)
            )
        }
    }
}

/// Falling rain, drifting clouds and lightning flashes. Conforms to
/// `Animatable` so drops fade in one at a time as the level changes.
private struct SkyWeather: View, @preconcurrency Animatable {
    var drops: Double
    var drift: Double
    var flash: Double

    @Environment(\.accessibilityReduceMotion) private var reduceMotion

    var animatableData: AnimatablePair<Double, AnimatablePair<Double, Double>> {
        get { AnimatablePair(drops, AnimatablePair(drift, flash)) }
        set {
            drops = newValue.first
            drift = newValue.second.first
            flash = newValue.second.second
        }
    }

    private struct Cloud {
        let top: Double, size: Double, duration: Double, delay: Double, opacity: Double
    }

    private static let clouds = [
        Cloud(top: 0.12, size: 120, duration: 90, delay: 10, opacity: 0.14),
        Cloud(top: 0.58, size: 180, duration: 130, delay: 70, opacity: 0.10),
        Cloud(top: 0.30, size: 80, duration: 70, delay: 40, opacity: 0.16),
        Cloud(top: 0.78, size: 100, duration: 110, delay: 95, opacity: 0.12),
    ]

    var body: some View {
        TimelineView(.animation(paused: reduceMotion)) { timeline in
            let time = timeline.date.timeIntervalSinceReferenceDate
            Canvas { context, size in
                drawClouds(in: &context, size: size, time: time)
                drawRain(in: &context, size: size, time: time)
                if !reduceMotion {
                    drawFlash(in: &context, size: size, time: time)
                }
            }
        }
    }

    private func drawClouds(in context: inout GraphicsContext, size: CGSize, time: Double) {
        guard drift > 0.01 else { return }
        var layer = context
        layer.addFilter(.blur(radius: 2))
        var symbol = layer.resolve(Image(systemName: "cloud.fill"))
        symbol.shading = .color(.white)
        for cloud in Self.clouds {
            let progress = ((time + cloud.delay) / cloud.duration).truncatingRemainder(dividingBy: 1)
            let x = size.width * (-0.25 + 1.4 * progress)
            layer.opacity = cloud.opacity * drift
            layer.draw(symbol, in: CGRect(x: x, y: size.height * cloud.top, width: cloud.size, height: cloud.size * 0.7))
        }
    }

    private func drawRain(in context: inout GraphicsContext, size: CGSize, time: Double) {
        for index in 0..<38 {
            let visibility = min(max(drops - Double(index), 0), 1)
            guard visibility > 0 else { break }
            let i = Double(index)
            let duration = 2.6 + (i * 7).truncatingRemainder(dividingBy: 10) / 6
            let delay = (i * 13).truncatingRemainder(dividingBy: 40) / 10
            let progress = ((time + delay) / duration).truncatingRemainder(dividingBy: 1)
            let fade = progress < 0.1 ? progress / 0.1 : (1 - progress) / 0.9
            let rect = CGRect(
                x: size.width * (i * 37.3).truncatingRemainder(dividingBy: 100) / 100,
                y: size.height * (-0.1 + 1.2 * progress),
                width: 1.5,
                height: 14 + Double(index % 4) * 6
            )
            context.fill(
                Path(roundedRect: rect, cornerRadius: 1),
                with: .color(.white.opacity(0.35 * fade * visibility))
            )
        }
    }

    private func drawFlash(in context: inout GraphicsContext, size: CGSize, time: Double) {
        guard flash > 0.01 else { return }
        let phase = time.truncatingRemainder(dividingBy: 9) / 9
        let intensity: Double = switch phase {
        case 0.92..<0.94: (phase - 0.92) / 0.02 * 0.18
        case 0.94..<0.96: (0.96 - phase) / 0.02 * 0.18
        case 0.96..<0.97: (phase - 0.96) / 0.01 * 0.10
        case 0.97...1: (1 - phase) / 0.03 * 0.10
        default: 0
        }
        guard intensity > 0 else { return }
        context.fill(Path(CGRect(origin: .zero, size: size)), with: .color(.white.opacity(intensity * flash)))
    }
}
