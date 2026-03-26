//
//  SymptomsView.swift
//  meningi
//
//  Created by Alex Kolesnikov on 22/03/2026.
//

import SwiftUI

struct SymptomsView: View {

    @State private var selectedSymptoms: Set<SymptomID> = []
    @State private var ageGroup: AgeGroup = .older
    @State private var isImmunocompromised: Bool = false
    @State private var presentedResult: ResultState? = nil

    @State private var currentSlideIndex: Int = 0
    @State private var hasTriggeredEmergency = false

    private let design = Design()

    private var slides: [Slide] {
        var items: [Slide] = [.setup]

        if ageGroup == .baby {
            items.append(.baby)
        }

        items.append(.emergency)
        items.append(.core)
        items.append(.sepsis)
        items.append(.generalOther)

        return items
    }

    private var currentSlide: Slide {
        slides[currentSlideIndex]
    }

    private var canGoBack: Bool {
        currentSlideIndex > 0
    }

    private var canGoForward: Bool {
        currentSlideIndex < slides.count - 1
    }

    private var selectedCount: Int {
        selectedSymptoms.count
    }

    var body: some View {
        NavigationStack {
            ZStack {
                design.background
                    .ignoresSafeArea()

                VStack(spacing: 0) {
                    headerBlock
                    progressBlock

                    TabView(selection: $currentSlideIndex) {
                        setupSlide
                            .tag(0)

                        if ageGroup == .baby {
                            symptomSlide(
                                title: SymptomSection.baby.title,
                                subtitle: SymptomSection.baby.subtitle,
                                symptoms: SymptomSection.baby.symptoms,
                                accent: design.teal,
                                systemImage: "figure.and.child.holdinghands"
                            )
                            .tag(indexFor(.baby))
                        }

                        symptomSlide(
                            title: SymptomSection.emergency.title,
                            subtitle: SymptomSection.emergency.subtitle,
                            symptoms: SymptomSection.emergency.symptoms,
                            accent: .red,
                            systemImage: "exclamationmark.triangle.fill"
                        )
                        .tag(indexFor(.emergency))

                        symptomSlide(
                            title: SymptomSection.core.title,
                            subtitle: SymptomSection.core.subtitle,
                            symptoms: SymptomSection.core.symptoms,
                            accent: design.teal,
                            systemImage: "brain.head.profile"
                        )
                        .tag(indexFor(.core))

                        symptomSlide(
                            title: SymptomSection.sepsis.title,
                            subtitle: SymptomSection.sepsis.subtitle,
                            symptoms: SymptomSection.sepsis.symptoms,
                            accent: design.amber,
                            systemImage: "waveform.path.ecg"
                        )
                        .tag(indexFor(.sepsis))

                        generalOtherSlide
                            .tag(indexFor(.generalOther))
                    }
                    .tabViewStyle(.page(indexDisplayMode: .never))
                    .animation(.easeInOut(duration: 0.25), value: currentSlideIndex)

                    bottomArea
                }
            }
            .navigationTitle("Symptom Checker")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(design.background, for: .navigationBar)
            .onChange(of: selectedSymptoms) { _ in
                checkForEmergencyEscalation()
            }
            .onChange(of: ageGroup) { _ in
                handleAgeGroupChange()
                checkForEmergencyEscalation()
            }
            .onChange(of: isImmunocompromised) { _ in
                checkForEmergencyEscalation()
            }
            .onAppear {
                hasTriggeredEmergency = false
            }
            .fullScreenCover(item: $presentedResult) { result in
                switch result {
                case .urgent:
                    UrgentView(
                        onEditSymptoms: {
                            presentedResult = nil
                        },
                        onRestart: {
                            resetChecker()
                        }
                    )

                case .seekAdvice:
                    SeekAdviceView(
                        onEditSymptoms: {
                            presentedResult = nil
                        },
                        onRestart: {
                            resetChecker()
                        }
                    )

                case .monitor:
                    MonitorView(
                        onEditSymptoms: {
                            presentedResult = nil
                        },
                        onRestart: {
                            resetChecker()
                        }
                    )

                case .emergency:
                    EmergencyView(
                        onRestart: {
                            resetChecker()
                        }
                    )
                }
            }
        }
    }
}

// MARK: - UI

private extension SymptomsView {

    var headerBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Check symptoms")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Select anything that matches.")
                .font(.caption)
                .foregroundStyle(design.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, design.horizontalPadding)
        .padding(.top, 10)
        .padding(.bottom, 8)
    }
    var progressBlock: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8) {
                Text(currentSlide.progressTitle(total: slides.count, index: currentSlideIndex + 1))
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(design.secondaryText)

                Spacer()

                Text("\(selectedCount) selected")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(selectedCount == 0 ? design.secondaryText : design.teal)
            }

            GeometryReader { geo in
                ZStack(alignment: .leading) {
                    Capsule()
                        .fill(.white.opacity(0.08))

                    Capsule()
                        .fill(design.teal)
                        .frame(width: geo.size.width * progressFraction)
                }
            }
            .frame(height: 7)
        }
        .padding(.horizontal, design.horizontalPadding)
        .padding(.bottom, 12)
    }

    var setupSlide: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                sectionHeader(title: "Setup", accent: design.teal)

                VStack(alignment: .leading, spacing: 10) {
                    Text("Age group")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)

                    Picker("Age group", selection: $ageGroup) {
                        ForEach(AgeGroup.allCases) { group in
                            Text(group.title).tag(group)
                        }
                    }
                    .pickerStyle(.segmented)
                    .tint(design.teal)
                }
                .darkCardStyle()

                VStack(alignment: .leading, spacing: 10) {
                    Toggle(isOn: $isImmunocompromised) {
                        Text("Immunocompromised")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(.white)
                    }
                    .toggleStyle(SwitchToggleStyle(tint: design.teal))
                }
                .darkCardStyle()
            }
            .padding(.horizontal, design.horizontalPadding)
            .padding(.bottom, 16)
        }
    }

    func symptomSlide(
        title: String,
        subtitle: String,
        symptoms: [SymptomItem],
        accent: Color,
        systemImage: String
    ) -> some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 10) {
                sectionHeader(title: title, accent: accent)

                VStack(spacing: 8) {
                    ForEach(symptoms) { symptom in
                        symptomRow(symptom, accent: accent)
                    }
                }
            }
            .padding(.horizontal, design.horizontalPadding)
            .padding(.bottom, 12)
        }
    }

    var generalOtherSlide: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: 12) {
                sectionHeader(title: "General + Other", accent: design.teal)

                Text("General")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.top, 2)

                VStack(spacing: 8) {
                    ForEach(SymptomSection.general.symptoms) { symptom in
                        symptomRow(symptom, accent: design.teal)
                    }
                }

                Text("Other")
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
                    .padding(.top, 4)

                VStack(spacing: 8) {
                    ForEach(SymptomSection.modifiers.symptoms) { symptom in
                        symptomRow(symptom, accent: design.amber)
                    }
                }
            }
            .padding(.horizontal, design.horizontalPadding)
            .padding(.bottom, 16)
        }
    }

    func sectionHeader(
        title: String,
        accent: Color
    ) -> some View {
        HStack(spacing: 8) {
            Circle()
                .fill(accent)
                .frame(width: 7, height: 7)

            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)
        }
        .padding(.top, 4)
        .padding(.bottom, 2)
    }

    func symptomRow(_ symptom: SymptomItem, accent: Color) -> some View {
        let isSelected = selectedSymptoms.contains(symptom.id)

        return Button {
            toggle(symptom.id)
        } label: {
            HStack(alignment: .top, spacing: 12) {
                Image(systemName: isSelected ? "checkmark.circle.fill" : "circle")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundStyle(isSelected ? accent : .white.opacity(0.28))
                    .padding(.top, 1)

                VStack(alignment: .leading, spacing: 3) {
                    Text(symptom.title)
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.leading)

                    if let note = symptom.note, (isSelected || accent == .red) {
                        Text(note)
                            .font(.caption)
                            .foregroundStyle(design.secondaryText)
                            .multilineTextAlignment(.leading)
                            .lineLimit(1)
                    }
                }

                Spacer(minLength: 0)
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .fill(isSelected ? accent.opacity(0.14) : design.rowFill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 16, style: .continuous)
                    .stroke(
                        isSelected ? accent.opacity(0.55) : .white.opacity(0.05),
                        lineWidth: 1
                    )
            )
        }
        .buttonStyle(.plain)
    }

    var bottomArea: some View {
        VStack(spacing: 8) {
            liveStatusPill

            HStack(spacing: 10) {
                Button {
                    goBack()
                } label: {
                    Text("Back")
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white.opacity(canGoBack ? 0.92 : 0.45))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(design.buttonSecondaryFill)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .stroke(.white.opacity(0.06), lineWidth: 1)
                        )
                }
                .buttonStyle(.plain)
                .disabled(!canGoBack)

                Button {
                    primaryAction()
                } label: {
                    Text(primaryButtonTitle)
                        .font(.subheadline.weight(.bold))
                        .foregroundStyle(.black.opacity(0.85))
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 14, style: .continuous)
                                .fill(design.teal)
                        )
                }
                .buttonStyle(.plain)
            }
        }
        .padding(.horizontal, design.horizontalPadding)
        .padding(.top, 8)
        .padding(.bottom, 10)
        .background(
            Rectangle()
                .fill(design.bottomBarFill)
                .ignoresSafeArea(edges: .bottom)
        )
        .overlay(alignment: .top) {
            Rectangle()
                .fill(.white.opacity(0.05))
                .frame(height: 1)
        }
    }

    var liveStatusPill: some View {
        let result = evaluateRisk()

        return HStack(alignment: .top, spacing: 10) {
            Image(systemName: result.iconName)
                .foregroundStyle(result.borderColor)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 4) {
                Text(result.shortLabel)
                    .font(.subheadline.weight(.semibold))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)

                Text(result.message)
                    .font(.caption)
                    .foregroundStyle(design.secondaryText)
                    .multilineTextAlignment(.leading)
                    .fixedSize(horizontal: false, vertical: true)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .layoutPriority(1)

            Spacer(minLength: 0)
        }
        .padding(.horizontal, 14)
        .padding(.vertical, 11)
        .background(result.backgroundColor)
        .overlay(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .stroke(result.borderColor.opacity(0.45), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}

// MARK: - Actions

private extension SymptomsView {

    func primaryAction() {
        if canGoForward {
            goForward()
            return
        }

        let result = evaluateRisk()
        presentedResult = result
    }

    func goBack() {
        guard canGoBack else { return }

        withAnimation(.easeInOut(duration: 0.25)) {
            currentSlideIndex -= 1
        }
    }

    func goForward() {
        guard canGoForward else { return }

        withAnimation(.easeInOut(duration: 0.25)) {
            currentSlideIndex += 1
        }
    }

    func handleAgeGroupChange() {
        if ageGroup != .baby, currentSlide == .baby {
            currentSlideIndex = indexFor(.emergency)
        }

        if ageGroup != .baby {
            selectedSymptoms.remove(.refusingFeeds)
            selectedSymptoms.remove(.highPitchedCry)
            selectedSymptoms.remove(.bulgingSoftSpot)
            selectedSymptoms.remove(.floppyOrUnresponsive)
            selectedSymptoms.remove(.unusualIrritability)
        }
    }

    func checkForEmergencyEscalation() {
        let result = evaluateRisk()

        guard result == .emergency else {
            hasTriggeredEmergency = false
            return
        }

        guard !hasTriggeredEmergency else { return }
        guard presentedResult == nil else { return }

        hasTriggeredEmergency = true

        DispatchQueue.main.async {
            presentedResult = .emergency
        }
    }

    func indexFor(_ slide: Slide) -> Int {
        slides.firstIndex(of: slide) ?? 0
    }
    
    func resetChecker() {
        selectedSymptoms.removeAll()
        ageGroup = .older
        isImmunocompromised = false
        presentedResult = nil
        currentSlideIndex = 0
        hasTriggeredEmergency = false
    }

    var progressFraction: CGFloat {
        guard !slides.isEmpty else { return 0 }
        return CGFloat(currentSlideIndex + 1) / CGFloat(slides.count)
    }

    var primaryButtonTitle: String {
        canGoForward ? "Next" : "Check symptoms"
    }
}

// MARK: - Logic

private extension SymptomsView {

    func toggle(_ symptom: SymptomID) {
        if selectedSymptoms.contains(symptom) {
            selectedSymptoms.remove(symptom)
        } else {
            selectedSymptoms.insert(symptom)
        }
    }

    func evaluateRisk() -> ResultState {
        let s = selectedSymptoms

        if s.contains(.nonBlanchingRash) ||
            s.contains(.seizure) ||
            s.contains(.hardToWake) ||
            s.contains(.confusion) ||
            s.contains(.severeBreathingDifficulty) ||
            s.contains(.paleBlueOrMottledSkin) ||
            s.contains(.floppyOrUnresponsive) {
            return .emergency
        }

        if has(.confusion, .drowsy, in: s) { return .emergency }
        if has(.coldHandsFeet, .paleBlueOrMottledSkin, in: s) { return .emergency }
        if has(.rapidBreathing, .drowsy, in: s) { return .emergency }
        if has(.rapidBreathing, .paleBlueOrMottledSkin, in: s) { return .emergency }
        if has(.fever, .coldHandsFeet, .muscleJointLimbPain, in: s) { return .emergency }

        let sepsisCount = count(in: s, from: SymptomSection.sepsis.symptoms.map(\.id))
        if sepsisCount >= 3 { return .emergency }

        if ageGroup == .baby {
            if has(.bulgingSoftSpot, .floppyOrUnresponsive, in: s) { return .emergency }
            if has(.refusingFeeds, .floppyOrUnresponsive, in: s) { return .emergency }
        }

        let coreCount = count(in: s, from: SymptomSection.core.symptoms.map(\.id))

        if coreCount >= 2 { return .urgent }
        if has(.fever, .headache, .stiffNeck, in: s) { return .urgent }
        if has(.headache, .stiffNeck, .sensitivityToLight, in: s) { return .urgent }
        if has(.repeatedVomiting, .drowsy, in: s) { return .urgent }
        if s.contains(.worseningQuickly) && (coreCount > 0 || sepsisCount > 0) { return .urgent }

        if ageGroup == .baby {
            let babyCount = count(in: s, from: SymptomSection.baby.symptoms.map(\.id))
            if babyCount >= 2 { return .urgent }
        }

        var score = 0
        score += 3 * coreCount
        score += 3 * sepsisCount
        score += 1 * count(in: s, from: SymptomSection.general.symptoms.map(\.id))

        if s.contains(.worseningQuickly) { score += 2 }
        if ageGroup == .baby { score += 2 }
        if isImmunocompromised { score += 2 }

        switch score {
        case 0...2:
            return .monitor
        case 3...5:
            return .seekAdvice
        case 6...8:
            return .urgent
        default:
            return .emergency
        }
    }

    func has(_ a: SymptomID, _ b: SymptomID, in set: Set<SymptomID>) -> Bool {
        set.contains(a) && set.contains(b)
    }

    func has(_ a: SymptomID, _ b: SymptomID, _ c: SymptomID, in set: Set<SymptomID>) -> Bool {
        set.contains(a) && set.contains(b) && set.contains(c)
    }

    func count(in set: Set<SymptomID>, from symptoms: [SymptomID]) -> Int {
        symptoms.filter { set.contains($0) }.count
    }
}

// MARK: - Models

private enum Slide: Hashable {
    case setup
    case baby
    case emergency
    case core
    case sepsis
    case generalOther

    var title: String {
        switch self {
        case .setup: return "Setup"
        case .baby: return "Baby"
        case .emergency: return "Emergency"
        case .core: return "Core"
        case .sepsis: return "Sepsis"
        case .generalOther: return "General + Other"
        }
    }

    func progressTitle(total: Int, index: Int) -> String {
        "\(title) • \(index) of \(total)"
    }
}

private enum AgeGroup: String, CaseIterable, Identifiable {
    case older
    case baby

    var id: String { rawValue }

    var title: String {
        switch self {
        case .older: return "Older child / teen / adult"
        case .baby: return "Baby under 1"
        }
    }
}

private enum ResultState: String, Equatable, Identifiable {
    case emergency
    case urgent
    case seekAdvice
    case monitor

    var id: String { rawValue }

    var title: String {
        switch self {
        case .emergency:
            return "Call emergency services now"
        case .urgent:
            return "Get urgent medical help today"
        case .seekAdvice:
            return "Seek medical advice promptly"
        case .monitor:
            return "Monitor closely"
        }
    }

    var shortLabel: String {
        switch self {
        case .emergency:
            return "Emergency"
        case .urgent:
            return "Urgent"
        case .seekAdvice:
            return "Prompt advice"
        case .monitor:
            return "Low current concern"
        }
    }

    var message: String {
        switch self {
        case .emergency:
            return "These symptoms may be consistent with meningitis or sepsis. Do not wait for more symptoms."
        case .urgent:
            return "A same-day medical assessment is recommended."
        case .seekAdvice:
            return "These symptoms may need prompt professional advice, especially if they worsen."
        case .monitor:
            return "Keep watching closely. Seek help promptly if symptoms worsen or new red flags appear."
        }
    }

    var actionText: String? {
        switch self {
        case .emergency:
            return "Act now."
        case .urgent:
            return "Do not leave this until later."
        case .seekAdvice:
            return nil
        case .monitor:
            return nil
        }
    }

    var iconName: String {
        switch self {
        case .emergency:
            return "exclamationmark.triangle.fill"
        case .urgent:
            return "cross.case.fill"
        case .seekAdvice:
            return "phone.fill"
        case .monitor:
            return "checkmark.circle.fill"
        }
    }

    var backgroundColor: Color {
        switch self {
        case .emergency:
            return Color.red.opacity(0.16)
        case .urgent:
            return Color.orange.opacity(0.18)
        case .seekAdvice:
            return Color.yellow.opacity(0.15)
        case .monitor:
            return Color.green.opacity(0.16)
        }
    }

    var borderColor: Color {
        switch self {
        case .emergency:
            return .red
        case .urgent:
            return .orange
        case .seekAdvice:
            return .yellow
        case .monitor:
            return .green
        }
    }
}

private enum SymptomID: String, Hashable, Identifiable {
    case fever
    case headache
    case stiffNeck
    case sensitivityToLight
    case repeatedVomiting
    case drowsy
    case hardToWake
    case confusion
    case seizure
    case nonBlanchingRash
    case coldHandsFeet
    case paleBlueOrMottledSkin
    case rapidBreathing
    case muscleJointLimbPain
    case severeBreathingDifficulty
    case worseningQuickly

    case refusingFeeds
    case highPitchedCry
    case bulgingSoftSpot
    case floppyOrUnresponsive
    case unusualIrritability

    case chillsShivering
    case weaknessFatigue

    var id: String { rawValue }
}

private struct SymptomItem: Identifiable {
    let id: SymptomID
    let title: String
    let note: String?
}

private struct SymptomSection: Identifiable {
    let id: String
    let title: String
    let subtitle: String
    let symptoms: [SymptomItem]

    static let core = SymptomSection(
        id: "core",
        title: "Core meningitis symptoms",
        subtitle: "These carry the most weight in the logic.",
        symptoms: [
            .init(id: .headache, title: "Bad or unusual headache", note: nil),
            .init(id: .stiffNeck, title: "Stiff neck", note: nil),
            .init(id: .sensitivityToLight, title: "Sensitivity to light", note: nil),
            .init(id: .repeatedVomiting, title: "Repeated vomiting", note: "More than a single episode"),
            .init(id: .drowsy, title: "Drowsy / unusually sleepy", note: nil),
            .init(id: .hardToWake, title: "Very hard to wake / unresponsive", note: "Emergency symptom on its own")
        ]
    )

    static let sepsis = SymptomSection(
        id: "sepsis",
        title: "Sepsis / circulation symptoms",
        subtitle: "These should not be treated as mild.",
        symptoms: [
            .init(id: .coldHandsFeet, title: "Cold hands and feet", note: nil),
            .init(id: .rapidBreathing, title: "Rapid breathing", note: nil),
            .init(id: .muscleJointLimbPain, title: "Muscle / joint / limb pain", note: "Especially severe limb pain"),
            .init(id: .paleBlueOrMottledSkin, title: "Pale, blue or mottled skin", note: nil)
        ]
    )

    static let general = SymptomSection(
        id: "general",
        title: "General infection symptoms",
        subtitle: "Less specific on their own.",
        symptoms: [
            .init(id: .fever, title: "Fever", note: nil),
            .init(id: .chillsShivering, title: "Chills / shivering", note: nil),
            .init(id: .weaknessFatigue, title: "General weakness / fatigue", note: nil)
        ]
    )

    static let emergency = SymptomSection(
        id: "emergency",
        title: "Immediate danger signs",
        subtitle: "Any of these should push the result to emergency.",
        symptoms: [
            .init(id: .confusion, title: "Confusion / delirium", note: "Emergency symptom on its own"),
            .init(id: .seizure, title: "Seizure", note: "Emergency symptom on its own"),
            .init(id: .nonBlanchingRash, title: "Non-blanching rash", note: "Emergency symptom on its own"),
            .init(id: .severeBreathingDifficulty, title: "Severe breathing difficulty", note: "Emergency symptom on its own")
        ]
    )

    static let modifiers = SymptomSection(
        id: "modifiers",
        title: "Other factors",
        subtitle: "These increase caution.",
        symptoms: [
            .init(id: .worseningQuickly, title: "Symptoms worsening quickly", note: "Over hours rather than days")
        ]
    )

    static let baby = SymptomSection(
        id: "baby",
        title: "Baby-specific symptoms",
        subtitle: "Babies often show different symptoms, so start here first.",
        symptoms: [
            .init(id: .refusingFeeds, title: "Refusing feeds", note: nil),
            .init(id: .highPitchedCry, title: "High-pitched cry", note: nil),
            .init(id: .bulgingSoftSpot, title: "Bulging soft spot", note: nil),
            .init(id: .floppyOrUnresponsive, title: "Floppy / unresponsive", note: "Emergency symptom on its own"),
            .init(id: .unusualIrritability, title: "Unusual irritability", note: nil)
        ]
    )
}

// MARK: - Design Tokens

private struct Design {
    let horizontalPadding: CGFloat = 16
    let sectionSpacing: CGFloat = 14

    let background = Color(red: 0.05, green: 0.06, blue: 0.08)

    let cardFill = Color(red: 0.10, green: 0.11, blue: 0.14)
    let cardTop = Color(red: 0.12, green: 0.13, blue: 0.17)
    let cardBottom = Color(red: 0.09, green: 0.10, blue: 0.13)

    let rowFill = Color(red: 0.11, green: 0.12, blue: 0.15)
    let bottomBarFill = Color(red: 0.08, green: 0.09, blue: 0.11)
    let buttonSecondaryFill = Color(red: 0.14, green: 0.15, blue: 0.18)

    let teal = Color(red: 0.18, green: 0.78, blue: 0.76)
    let amber = Color(red: 0.95, green: 0.70, blue: 0.24)

    let bodyText = Color.white.opacity(0.92)
    let secondaryText = Color.white.opacity(0.68)
}

private extension View {
    func darkCardStyle() -> some View {
        self
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .fill(Color(red: 0.10, green: 0.11, blue: 0.14))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20, style: .continuous)
                    .stroke(.white.opacity(0.05), lineWidth: 1)
            )
            .shadow(color: .black.opacity(0.18), radius: 14, y: 6)
    }
}

#Preview {
    SymptomsView()
}
