import SwiftUI

struct VaccinationsView: View {
    private let design = Design()
    @State private var expandedVaccine: VaccineItem? = nil

    var body: some View {
        NavigationStack {
            GeometryReader { geometry in
                ZStack {
                    design.background
                        .ignoresSafeArea()

                    VStack(spacing: 0) {
                        headerBlock

                        ScrollViewReader { proxy in
                            ScrollView(showsIndicators: false) {
                                VStack(alignment: .leading, spacing: design.sectionSpacing) {
                                    introBlock

                                    VStack(spacing: 12) {
                                        ForEach(VaccineItem.allCases, id: \.self) { vaccine in
                                            vaccineAccordionCard(vaccine, proxy: proxy)
                                                .id(vaccine)
                                        }
                                    }

                                    // Extra room so centre anchoring still works
                                    // even when all cards are collapsed.
                                    Color.clear
                                        .frame(height: geometry.size.height * 0.28)
                                }
                                .padding(.horizontal, design.horizontalPadding)
                                .padding(.bottom, 32)
                                .frame(
                                    minHeight: geometry.size.height,
                                    alignment: .top
                                )
                            }
                        }
                    }
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

// MARK: - UI

private extension VaccinationsView {

    var headerBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Vaccinations")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Vaccines can reduce risk.")
                .font(.caption)
                .foregroundStyle(design.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, design.horizontalPadding)
        .padding(.top, 10)
        .padding(.bottom, 12)
    }

    var introBlock: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Several vaccines reduce the risk of infections that can cause meningitis.")
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)

            Text("Which ones are offered depends on country and schedule.")
                .font(.subheadline)
                .foregroundStyle(design.secondaryText)
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

    func vaccineAccordionCard(
        _ vaccine: VaccineItem,
        proxy: ScrollViewProxy
    ) -> some View {
        let isExpanded = expandedVaccine == vaccine
        let accent = vaccine.accent

        return VStack(alignment: .leading, spacing: 0) {
            Button {
                if isExpanded {
                    withAnimation(.easeInOut(duration: 0.24)) {
                        expandedVaccine = nil
                    }
                } else {
                    withAnimation(.easeInOut(duration: 0.30)) {
                        expandedVaccine = vaccine
                    }

                    DispatchQueue.main.async {
                        withAnimation(.easeInOut(duration: 0.20)) {
                            proxy.scrollTo(vaccine, anchor: .center)
                        }
                    }
                }
            } label: {
                HStack(spacing: 12) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 11, style: .continuous)
                            .fill(accent.opacity(isExpanded ? 0.24 : 0.16))
                            .frame(width: 38, height: 38)

                        Image(systemName: "syringe.fill")
                            .font(.system(size: 15, weight: .bold))
                            .foregroundStyle(accent)
                    }

                    VStack(alignment: .leading, spacing: 3) {
                        Text(vaccine.title)
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity, alignment: .leading)

                        Text(vaccine.shortLine)
                            .font(.caption)
                            .foregroundStyle(design.secondaryText)
                            .frame(maxWidth: .infinity, alignment: .leading)
                    }

                    Image(systemName: "chevron.down")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundStyle(isExpanded ? .white.opacity(0.92) : design.secondaryText)
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                }
                .padding(16)
                .contentShape(Rectangle())
            }
            .buttonStyle(.plain)

            if isExpanded {
                VStack(alignment: .leading, spacing: 12) {
                    Rectangle()
                        .fill(accent.opacity(0.22))
                        .frame(height: 1)

                    Text(vaccine.summary)
                        .font(.subheadline.weight(.semibold))
                        .foregroundStyle(.white)
                        .fixedSize(horizontal: false, vertical: true)

                    bulletList(vaccine.points, accent: accent)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 16)
                .transition(.opacity.animation(.easeInOut(duration: 0.30)))
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(
                    LinearGradient(
                        colors: isExpanded
                            ? [design.cardFill, accent.opacity(0.10)]
                            : [design.cardFill, design.cardFill],
                        startPoint: .topLeading,
                        endPoint: .bottomTrailing
                    )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(
                    isExpanded ? accent.opacity(0.45) : .white.opacity(0.05),
                    lineWidth: isExpanded ? 1.2 : 1
                )
        )
        .shadow(
            color: isExpanded ? accent.opacity(0.16) : .clear,
            radius: isExpanded ? 14 : 0,
            x: 0,
            y: isExpanded ? 7 : 0
        )
    }

    func bulletList(_ items: [String], accent: Color) -> some View {
        VStack(alignment: .leading, spacing: 10) {
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(accent)
                        .frame(width: 6, height: 6)
                        .padding(.top, 6)

                    Text(item)
                        .font(.footnote)
                        .foregroundStyle(design.bodyText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
            }
        }
    }
}

// MARK: - Data

private enum VaccineItem: CaseIterable {
    case menB
    case menACWY
    case pneumococcal
    case hib

    var title: String {
        switch self {
        case .menB: return "MenB"
        case .menACWY: return "MenACWY"
        case .pneumococcal: return "Pneumococcal"
        case .hib: return "Hib"
        }
    }

    var shortLine: String {
        switch self {
        case .menB: return "Group B meningococcus"
        case .menACWY: return "Groups A, C, W, Y"
        case .pneumococcal: return "Streptococcus pneumoniae"
        case .hib: return "Haemophilus influenzae type b"
        }
    }

    var summary: String {
        switch self {
        case .menB:
            return "Protects against meningococcal group B, a major cause of invasive bacterial meningitis."
        case .menACWY:
            return "Protects against four other meningococcal groups linked to outbreaks and severe invasive disease."
        case .pneumococcal:
            return "Protects against pneumococcal infection, which can cause meningitis, sepsis, and pneumonia."
        case .hib:
            return "Protects against Hib, once a major cause of meningitis in young children."
        }
    }

    var points: [String] {
        switch self {
        case .menB:
            return [
                "Targets a different bacterial group from MenACWY",
                "Especially relevant where group B disease is a major driver of cases",
                "Designed specifically for meningococcal B strains"
            ]

        case .menACWY:
            return [
                "Covers four meningococcal groups not included in MenB",
                "Particularly relevant because strain patterns vary across regions",
                "Often used to broaden protection beyond group B"
            ]

        case .pneumococcal:
            return [
                "Targets pneumococcus rather than meningococcus",
                "Important because this bacterium causes several serious invasive infections",
                "Protection depends on the specific pneumococcal vaccine used"
            ]

        case .hib:
            return [
                "Targets Hib specifically, not other Haemophilus bacteria",
                "Had a major impact on childhood meningitis where uptake became high",
                "Now much less common in well-vaccinated populations"
            ]
        }
    }

    var accent: Color {
        switch self {
        case .menB:
            return Color(red: 0.20, green: 0.78, blue: 0.76)
        case .menACWY:
            return Color(red: 0.37, green: 0.62, blue: 0.98)
        case .pneumococcal:
            return Color(red: 0.98, green: 0.61, blue: 0.22)
        case .hib:
            return Color(red: 0.64, green: 0.49, blue: 0.95)
        }
    }
}

// MARK: - Design

private struct Design {
    let horizontalPadding: CGFloat = 16
    let sectionSpacing: CGFloat = 18

    let background = Color(red: 0.04, green: 0.07, blue: 0.11)
    let cardFill = Color(red: 0.09, green: 0.13, blue: 0.19)

    let bodyText = Color.white.opacity(0.88)
    let secondaryText = Color.white.opacity(0.68)
}

#Preview {
    VaccinationsView()
}
