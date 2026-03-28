//
//  AboutView.swift
//  meningi
//
//  Created by Alex Kolesnikov on 26/03/2026.
//

import SwiftUI

struct AboutView: View {
    private let design = Design()

    @State private var animateScrollCue = false
    @State private var rawHeroProgress: CGFloat = 0
    @State private var targetNarrativeProgress: CGFloat = 0
    @State private var narrativeProgress: CGFloat = 0
    @State private var lastFrameTime: TimeInterval = 0

    var body: some View {
        TimelineView(.animation) { context in
            let timestamp = context.date.timeIntervalSinceReferenceDate

            GeometryReader { screen in
                let topInset = screen.safeAreaInsets.top
                let heroHeight = screen.size.height
                let viewportWidth = screen.size.width
                let heroTrackHeight = max(heroHeight * 11.0, 5600)

                ZStack(alignment: .top) {
                    design.background
                        .ignoresSafeArea()

                    ScrollView(showsIndicators: false) {
                        ZStack(alignment: .top) {
                            GeometryReader { proxy in
                                let minY = proxy.frame(in: .named("ABOUT_SCROLL")).minY
                                let maxTravel = max(heroTrackHeight - heroHeight, 1)
                                let progress = clamp((-minY) / maxTravel, lower: 0, upper: 1)

                                Color.clear
                                    .onAppear {
                                        let timelineProgress = narrativeTimeline(from: progress)
                                        rawHeroProgress = progress
                                        targetNarrativeProgress = timelineProgress
                                        narrativeProgress = timelineProgress
                                    }
                                    .onChange(of: progress) { newValue in
                                        rawHeroProgress = newValue
                                        targetNarrativeProgress = narrativeTimeline(from: newValue)
                                    }
                            }
                            .frame(height: heroTrackHeight)

                            contentSection()
                                .padding(.top, heroTrackHeight - heroHeight * 0.50)
                                .opacity(realCardsOpacity(progress: narrativeProgress))
                        }
                        .padding(.bottom, 80)
                    }
                    .coordinateSpace(name: "ABOUT_SCROLL")
                    .ignoresSafeArea(edges: .top)

                    heroOverlay(
                        topInset: topInset,
                        heroHeight: heroHeight,
                        viewportWidth: viewportWidth,
                        trackHeight: heroTrackHeight
                    )

                    pinnedHeader(topInset: topInset, heroHeight: heroHeight)
                }
                .overlay(
                    Color.clear
                        .frame(width: 0, height: 0)
                        .onAppear {
                            if lastFrameTime == 0 {
                                lastFrameTime = timestamp
                            }
                        }
                        .onChange(of: timestamp) { newValue in
                            updateNarrativeProgress(timestamp: newValue)
                        }
                )
            }
        }
        .toolbar(.hidden, for: .navigationBar)
        .onAppear {
            animateScrollCue = true
        }
    }
}

// MARK: - Pinned Header

private extension AboutView {
    func pinnedHeader(topInset: CGFloat, heroHeight: CGFloat) -> some View {
        let solidProgress = headerSolidProgress(progress: narrativeProgress)
        let headerYOffset = clamp((820 - heroHeight) * 0.11, lower: -18, upper: 18)

        return VStack(alignment: .leading, spacing: 4) {
            Text("About")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Background and purpose.")
                .font(.caption)
                .foregroundStyle(design.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, design.horizontalPadding)
        .padding(.top, topInset - 40 + headerYOffset)
        .padding(.bottom, 10)
        .background(
            ZStack {
                Rectangle()
                    .fill(design.background)
                    .opacity(solidProgress)

                LinearGradient(
                    colors: [
                        Color.black.opacity(0.26 * (1 - solidProgress)),
                        Color.black.opacity(0.10 * (1 - solidProgress)),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                LinearGradient(
                    colors: [
                        design.background.opacity(0.985 * solidProgress),
                        design.background.opacity(0.95 * solidProgress),
                        Color.clear
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )
            }
            .ignoresSafeArea(edges: .top)
        )
        .overlay(
            Rectangle()
                .fill(.white.opacity(0.06 * solidProgress))
                .frame(height: 1),
            alignment: .bottom
        )
        .animation(.easeInOut(duration: 0.18), value: solidProgress)
        .zIndex(20)
    }
}

// MARK: - Hero Experience

private extension AboutView {

    func heroOverlay(
        topInset: CGFloat,
        heroHeight: CGFloat,
        viewportWidth: CGFloat,
        trackHeight: CGFloat
    ) -> some View {
        let maxTravel = max(trackHeight - heroHeight, 1)
        let virtualMinY = -rawHeroProgress * maxTravel

        return heroVisual(
            topInset: topInset,
            heroHeight: heroHeight,
            viewportWidth: viewportWidth,
            imageProgress: rawHeroProgress,
            textProgress: narrativeProgress,
            minY: virtualMinY
        )
        .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .top)
        .opacity(heroOpacity(progress: narrativeProgress))
        .allowsHitTesting(false)
        .ignoresSafeArea()
    }

    func heroVisual(
        topInset: CGFloat,
        heroHeight: CGFloat,
        viewportWidth: CGFloat,
        imageProgress: CGFloat,
        textProgress: CGFloat,
        minY: CGFloat
    ) -> some View {
        let titleWidth = min(viewportWidth * 0.84, 470.0)
        let lineSize = clamp(viewportWidth * 0.082, lower: 27, upper: 40)
        let bodySize = clamp(viewportWidth * 0.040, lower: 15, upper: 18)

        let imageHeight = heroHeight * 1.18 + imageStretch(minY: minY)
        let captionZoomProgress = captionDrivenZoomProgress(textProgress)
        let zoomScale = 1.12 + captionZoomProgress * 0.34

        return ZStack(alignment: .top) {
            imageGlow(progress: imageProgress)
                .frame(height: heroHeight * 1.20)
                .offset(y: heroHeight * 0.03)

            Image("max")
                .resizable()
                .scaledToFill()
                .frame(width: viewportWidth, height: imageHeight, alignment: .top)
                .scaleEffect(zoomScale, anchor: .top)
                .offset(y: imageOffset(minY: minY, progress: imageProgress))
                .clipped()

            ZStack {
                LinearGradient(
                    colors: [
                        Color.black.opacity(0.04),
                        Color.black.opacity(0.12),
                        Color.black.opacity(0.24),
                        Color.black.opacity(0.50),
                        design.background.opacity(0.90)
                    ],
                    startPoint: .top,
                    endPoint: .bottom
                )

                RadialGradient(
                    colors: [
                        design.teal.opacity(0.14 + Double(imageProgress) * 0.06),
                        Color.clear
                    ],
                    center: .bottom,
                    startRadius: 20,
                    endRadius: viewportWidth * 0.96
                )
                .blendMode(.screen)
            }

            VStack(spacing: 0) {
                Spacer(minLength: 0)

                heroTextStack(
                    progress: textProgress,
                    lineSize: lineSize,
                    bodySize: bodySize,
                    maxWidth: titleWidth
                )
                .padding(.horizontal, design.horizontalPadding)

                scrollCue(progress: textProgress)
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    .padding(.horizontal, design.horizontalPadding)
                    .padding(.top, 14)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .bottomLeading)
            .padding(.bottom, max(heroHeight * 0.16, 118))

            bottomFadeOverlay(heroHeight: heroHeight, progress: narrativeProgress)
                .frame(maxHeight: .infinity, alignment: .bottom)
        }
        .frame(width: viewportWidth, height: heroHeight, alignment: .top)
        .ignoresSafeArea()
    }

    func imageGlow(progress: CGFloat) -> some View {
        ZStack {
            Ellipse()
                .fill(design.teal.opacity(0.18 + Double(progress) * 0.07))
                .blur(radius: 60)
                .scaleEffect(x: 1.28, y: 0.56)

            Ellipse()
                .fill(Color.white.opacity(0.06))
                .blur(radius: 84)
                .scaleEffect(x: 0.92, y: 0.36)
                .offset(y: -8)
        }
    }

    func bottomFadeOverlay(heroHeight: CGFloat, progress: CGFloat) -> some View {
        let fadeOpacity = bottomOverlayOpacity(progress: progress)

        return LinearGradient(
            colors: [
                Color.clear,
                design.background.opacity(0.12),
                design.background.opacity(0.34),
                design.background
            ],
            startPoint: .top,
            endPoint: .bottom
        )
        .frame(height: heroHeight * 0.26)
        .opacity(fadeOpacity)
    }

    func heroTextStack(
        progress: CGFloat,
        lineSize: CGFloat,
        bodySize: CGFloat,
        maxWidth: CGFloat
    ) -> some View {
        ZStack(alignment: .bottomLeading) {
            phaseView(
                title: "My younger brother developed meningitis, even though he was vaccinated.",
                progress: progress,
                start: 0.00,
                fadeInEnd: 0.05,
                holdEnd: 0.12,
                end: 0.18,
                lineSize: lineSize,
                maxWidth: maxWidth
            )

            phaseView(
                title: "He became seriously ill quickly.",
                progress: progress,
                start: 0.18,
                fadeInEnd: 0.23,
                holdEnd: 0.31,
                end: 0.37,
                lineSize: lineSize,
                maxWidth: maxWidth
            )

            phaseView(
                title: "He required intensive care.",
                progress: progress,
                start: 0.37,
                fadeInEnd: 0.41,
                holdEnd: 0.47,
                end: 0.50,
                lineSize: lineSize,
                maxWidth: maxWidth
            )

            finalPhaseView(
                title: "He survived because urgent medical help was reached in time.",
                lingeringLine: "Act early. Save a life.",
                progress: progress,
                titleStart: 0.50,
                titleFadeInEnd: 0.58,
                titleHoldEnd: 0.70,
                titleFadeOutEnd: 0.78,
                lingerStart: 0.50,
                lingerSmallHoldEnd: 0.78,
                lingerPromoteEnd: 0.90,
                lingerLargeHoldEnd: 0.975,
                lingerFadeOutEnd: 1.0,
                lineSize: lineSize,
                bodySize: bodySize,
                maxWidth: maxWidth
            )
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .frame(height: 220, alignment: .bottomLeading)
    }

    func phaseView(
        title: String,
        progress: CGFloat,
        start: CGFloat,
        fadeInEnd: CGFloat,
        holdEnd: CGFloat,
        end: CGFloat,
        lineSize: CGFloat,
        maxWidth: CGFloat
    ) -> some View {
        let opacity = phaseOpacity(
            progress: progress,
            start: start,
            fadeInEnd: fadeInEnd,
            holdEnd: holdEnd,
            end: end
        )

        let y = phaseYOffset(
            progress: progress,
            start: start,
            fadeInEnd: fadeInEnd,
            holdEnd: holdEnd,
            end: end
        )

        let blur = phaseBlur(
            progress: progress,
            start: start,
            fadeInEnd: fadeInEnd,
            holdEnd: holdEnd,
            end: end
        )

        return VStack(alignment: .leading, spacing: 12) {
            Text(title)
                .font(.system(size: lineSize, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: maxWidth, alignment: .leading)
        .opacity(opacity)
        .blur(radius: blur)
        .offset(y: y)
    }

    func finalPhaseView(
        title: String,
        lingeringLine: String,
        progress: CGFloat,
        titleStart: CGFloat,
        titleFadeInEnd: CGFloat,
        titleHoldEnd: CGFloat,
        titleFadeOutEnd: CGFloat,
        lingerStart: CGFloat,
        lingerSmallHoldEnd: CGFloat,
        lingerPromoteEnd: CGFloat,
        lingerLargeHoldEnd: CGFloat,
        lingerFadeOutEnd: CGFloat,
        lineSize: CGFloat,
        bodySize: CGFloat,
        maxWidth: CGFloat
    ) -> some View {
        let titleOpacity = phaseOpacity(
            progress: progress,
            start: titleStart,
            fadeInEnd: titleFadeInEnd,
            holdEnd: titleHoldEnd,
            end: titleFadeOutEnd
        )

        let titleY = phaseYOffset(
            progress: progress,
            start: titleStart,
            fadeInEnd: titleFadeInEnd,
            holdEnd: titleHoldEnd,
            end: titleFadeOutEnd
        )

        let titleBlur = phaseBlur(
            progress: progress,
            start: titleStart,
            fadeInEnd: titleFadeInEnd,
            holdEnd: titleHoldEnd,
            end: titleFadeOutEnd
        )

        let lingeringOpacity = lingeringLineOpacity(
            progress: progress,
            start: lingerStart,
            smallHoldEnd: lingerSmallHoldEnd,
            largeHoldEnd: lingerLargeHoldEnd,
            fadeOutEnd: lingerFadeOutEnd
        )

        let lingeringYOffset = lingeringLineYOffset(
            progress: progress,
            start: lingerStart,
            end: lingerPromoteEnd
        )

        let lingeringSize = lingeringLineSize(
            progress: progress,
            smallHoldEnd: lingerSmallHoldEnd,
            promoteEnd: lingerPromoteEnd,
            smallSize: bodySize * 1.02,
            largeSize: lineSize * 0.94
        )

        let lingeringWeight: Font.Weight = progress >= lingerPromoteEnd ? .bold : .semibold
        let lingeringSpacing: CGFloat = 12

        return VStack(alignment: .leading, spacing: lingeringSpacing) {
            Text(title)
                .font(.system(size: lineSize, weight: .bold, design: .rounded))
                .foregroundStyle(.white)
                .lineSpacing(2)
                .fixedSize(horizontal: false, vertical: true)
                .opacity(titleOpacity)
                .blur(radius: titleBlur)
                .offset(y: titleY)

            Text(lingeringLine)
                .font(.system(size: lingeringSize, weight: lingeringWeight, design: .rounded))
                .foregroundStyle(.white)
                .fixedSize(horizontal: false, vertical: true)
                .opacity(lingeringOpacity)
                .offset(y: lingeringYOffset)
        }
        .frame(maxWidth: maxWidth, alignment: .leading)
    }

    func scrollCue(progress: CGFloat) -> some View {
        HStack(spacing: 8) {
            VStack(spacing: -4) {
                Image(systemName: "chevron.down")
                Image(systemName: "chevron.down")
            }
            .font(.system(size: 12, weight: .bold))
            .offset(y: animateScrollCue ? 5 : -2)
            .animation(
                .easeInOut(duration: 0.95).repeatForever(autoreverses: true),
                value: animateScrollCue
            )

            Text("Scroll down slowly")
                .font(.caption.weight(.semibold))
        }
        .foregroundStyle(.white.opacity(0.88))
        .opacity(scrollCueOpacity(progress: progress))
    }
}

// MARK: - Main Content

private extension AboutView {

    func contentSection() -> some View {
        cardsStack
            .padding(.horizontal, design.horizontalPadding)
    }

    var cardsStack: some View {
        VStack(alignment: .leading, spacing: design.sectionSpacing) {
            lessonCard
            purposeCard
            useCard
        }
    }

    func cardsHandoffOverlay(heroHeight: CGFloat) -> some View {
        EmptyView()
    }

    var lessonCard: some View {
        infoCard(
            title: "What that showed",
            icon: "exclamationmark.shield",
            accent: design.sepsisOrange
        ) {
            VStack(alignment: .leading, spacing: 10) {
                bodyLine("Vaccination matters, but it does not remove all risk.")
                bodyLine("Early symptoms may be vague, incomplete, or easy to dismiss.")
                bodyLine("If symptoms are worsening or something feels seriously wrong, speed matters.")
            }
        }
    }

    var purposeCard: some View {
        infoCard(
            title: "Purpose",
            icon: "target",
            accent: design.teal
        ) {
            VStack(alignment: .leading, spacing: 10) {
                bodyLine("This app was created to support earlier recognition of serious symptoms and faster action when needed.")
                bodyLine("It brings together warning signs, urgency cues, and clear next steps in one place.")
            }
        }
    }

    var useCard: some View {
        infoCard(
            title: "How it should be used",
            icon: "hand.raised.fill",
            accent: design.teal
        ) {
            VStack(alignment: .leading, spacing: 10) {
                bodyLine("It is an awareness tool, not a diagnosis.")
                bodyLine("It should support judgement, not replace medical care.")
                bodyLine("If someone seems seriously unwell, seek urgent help.")
            }
        }
    }

    func infoCard<Content: View>(
        title: String,
        icon: String,
        accent: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(accent.opacity(0.16))
                        .frame(width: 34, height: 34)

                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(accent)
                }

                Text(title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
            }

            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(design.cardFill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(.white.opacity(0.05), lineWidth: 1)
        )
    }

    func bodyLine(_ text: String) -> some View {
        Text(text)
            .font(.body)
            .foregroundStyle(design.bodyText)
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}

// MARK: - Maths

private extension AboutView {

    func updateNarrativeProgress(timestamp: TimeInterval) {
        if lastFrameTime == 0 {
            lastFrameTime = timestamp
            return
        }

        let dt = min(max(timestamp - lastFrameTime, 0), 1.0 / 20.0)
        lastFrameTime = timestamp

        let forwardRate: CGFloat = 0.06
        let backwardRate: CGFloat = 0.42

        let delta = targetNarrativeProgress - narrativeProgress
        if abs(delta) < 0.0001 { return }

        let maxStep = (delta > 0 ? forwardRate : backwardRate) * CGFloat(dt)
        let step = min(abs(delta), maxStep)

        narrativeProgress += delta > 0 ? step : -step
    }

    func clamp(_ value: CGFloat, lower: CGFloat, upper: CGFloat) -> CGFloat {
        min(max(value, lower), upper)
    }

    func remap(
        _ value: CGFloat,
        from: ClosedRange<CGFloat>,
        to: ClosedRange<CGFloat>
    ) -> CGFloat {
        let t = (value - from.lowerBound) / max(from.upperBound - from.lowerBound, 0.0001)
        return to.lowerBound + (to.upperBound - to.lowerBound) * t
    }

    func narrativeTimeline(from raw: CGFloat) -> CGFloat {
        let p = clamp(raw, lower: 0, upper: 1)

        switch p {
        case 0..<0.20:
            return remap(p, from: 0.00...0.20, to: 0.00...0.18)

        case 0.20..<0.38:
            return remap(p, from: 0.20...0.38, to: 0.18...0.37)

        case 0.38..<0.54:
            return remap(p, from: 0.38...0.54, to: 0.37...0.50)

        case 0.54..<0.76:
            return remap(p, from: 0.54...0.76, to: 0.50...0.72)

        case 0.76..<0.90:
            return remap(p, from: 0.76...0.90, to: 0.72...0.90)

        default:
            return remap(p, from: 0.90...1.00, to: 0.90...1.00)
        }
    }

    func captionDrivenZoomProgress(_ progress: CGFloat) -> CGFloat {
        switch progress {
        case 0..<0.18:
            return remap(progress, from: 0.00...0.18, to: 0.00...0.18)

        case 0.18..<0.37:
            return remap(progress, from: 0.18...0.37, to: 0.18...0.40)

        case 0.37..<0.50:
            return remap(progress, from: 0.37...0.50, to: 0.40...0.56)

        case 0.50..<0.78:
            return remap(progress, from: 0.50...0.78, to: 0.56...0.82)

        case 0.78..<0.90:
            return remap(progress, from: 0.78...0.90, to: 0.82...0.94)

        default:
            return remap(progress, from: 0.90...1.00, to: 0.94...1.00)
        }
    }

    func imageStretch(minY: CGFloat) -> CGFloat {
        max(minY, 0)
    }

    func imageOffset(minY: CGFloat, progress: CGFloat) -> CGFloat {
        if minY > 0 {
            return -minY * 0.10
        } else {
            return minY * 0.02 - progress * 10
        }
    }

    func headerSolidProgress(progress: CGFloat) -> Double {
        if progress <= 0.978 { return 0 }
        if progress >= 0.996 { return 1 }
        let t = (progress - 0.978) / 0.018
        return min(1, max(0, Double(t)))
    }

    func heroOpacity(progress: CGFloat) -> Double {
        if progress < 0.972 { return 1 }
        let t = 1 - ((progress - 0.972) / 0.020)
        return max(0, Double(t))
    }

    func overlayCardsOpacity(progress: CGFloat) -> Double {
        if progress <= 0.982 { return 0 }
        if progress < 0.987 {
            let t = (progress - 0.982) / 0.005
            return min(1, Double(t))
        }
        if progress <= 0.989 { return 1 }

        let t = 1 - ((progress - 0.989) / 0.003)
        return max(0, Double(t))
    }

    func overlayCardsYOffset(progress: CGFloat) -> CGFloat {
        if progress <= 0.982 { return 12 }
        if progress >= 0.989 { return 0 }

        let t = (progress - 0.982) / 0.007
        return (1 - t) * 12
    }

    func realCardsOpacity(progress: CGFloat) -> Double {
        if progress <= 0.968 { return 0 }
        if progress >= 0.978 { return 1 }

        let t = (progress - 0.968) / 0.010
        return min(1, Double(t))
    }

    func bottomOverlayOpacity(progress: CGFloat) -> Double {
        if progress < 0.982 { return 1 }
        let t = 1 - ((progress - 0.982) / 0.018)
        return max(0, Double(t))
    }

    func phaseOpacity(
        progress: CGFloat,
        start: CGFloat,
        fadeInEnd: CGFloat,
        holdEnd: CGFloat,
        end: CGFloat
    ) -> Double {
        if progress <= start || progress >= end { return 0 }

        if progress < fadeInEnd {
            let t = (progress - start) / max(fadeInEnd - start, 0.0001)
            return Double(t)
        }

        if progress <= holdEnd {
            return 1
        }

        let t = (end - progress) / max(end - holdEnd, 0.0001)
        return max(0, Double(t))
    }

    func phaseYOffset(
        progress: CGFloat,
        start: CGFloat,
        fadeInEnd: CGFloat,
        holdEnd: CGFloat,
        end: CGFloat
    ) -> CGFloat {
        let opacity = CGFloat(
            phaseOpacity(
                progress: progress,
                start: start,
                fadeInEnd: fadeInEnd,
                holdEnd: holdEnd,
                end: end
            )
        )
        return (1 - opacity) * 18
    }

    func phaseBlur(
        progress: CGFloat,
        start: CGFloat,
        fadeInEnd: CGFloat,
        holdEnd: CGFloat,
        end: CGFloat
    ) -> CGFloat {
        let opacity = CGFloat(
            phaseOpacity(
                progress: progress,
                start: start,
                fadeInEnd: fadeInEnd,
                holdEnd: holdEnd,
                end: end
            )
        )
        return (1 - opacity) * 2.2
    }

    func lingeringLineOpacity(
        progress: CGFloat,
        start: CGFloat,
        smallHoldEnd: CGFloat,
        largeHoldEnd: CGFloat,
        fadeOutEnd: CGFloat
    ) -> Double {
        if progress <= start { return 0 }

        if progress < smallHoldEnd {
            let t = (progress - start) / max(smallHoldEnd - start, 0.0001)
            return min(1, Double(t))
        }

        if progress <= largeHoldEnd {
            return 1
        }

        if progress < fadeOutEnd {
            let t = 1 - ((progress - largeHoldEnd) / max(fadeOutEnd - largeHoldEnd, 0.0001))
            return max(0, Double(t))
        }

        return 0
    }

    func lingeringLineYOffset(
        progress: CGFloat,
        start: CGFloat,
        end: CGFloat
    ) -> CGFloat {
        if progress <= start {
            return 10
        }

        if progress >= end {
            return 0
        }

        let t = (progress - start) / max(end - start, 0.0001)
        return (1 - t) * 10
    }

    func lingeringLineSize(
        progress: CGFloat,
        smallHoldEnd: CGFloat,
        promoteEnd: CGFloat,
        smallSize: CGFloat,
        largeSize: CGFloat
    ) -> CGFloat {
        if progress <= smallHoldEnd {
            return smallSize
        }

        if progress >= promoteEnd {
            return largeSize
        }

        let t = (progress - smallHoldEnd) / max(promoteEnd - smallHoldEnd, 0.0001)
        return smallSize + (largeSize - smallSize) * t
    }

    func scrollCueOpacity(progress: CGFloat) -> Double {
        if progress < 0.08 { return 1 }
        let t = 1 - ((progress - 0.08) / 0.12)
        return max(0, Double(t))
    }
}

// MARK: - Design

private struct Design {
    let horizontalPadding: CGFloat = 16
    let sectionSpacing: CGFloat = 18

    let background = Color(red: 0.04, green: 0.07, blue: 0.11)
    let cardFill = Color(red: 0.09, green: 0.13, blue: 0.19)

    let teal = Color(red: 0.18, green: 0.78, blue: 0.76)
    let sepsisOrange = Color(red: 0.96, green: 0.56, blue: 0.20)

    let bodyText = Color.white.opacity(0.92)
    let secondaryText = Color.white.opacity(0.68)
}

#Preview {
    NavigationStack {
        AboutView()
    }
}
