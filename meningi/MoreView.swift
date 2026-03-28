import SwiftUI

struct MoreView: View {
    private let design = Design()

    var body: some View {
        NavigationStack {
            ZStack {
                design.background
                    .ignoresSafeArea()

                VStack(alignment: .leading, spacing: 20) {
                    headerBlock

                    VStack(spacing: 12) {
                        NavigationLink {
                            AboutView()
                        } label: {
                            moreRow("About", systemImage: "info.circle")
                        }
                        .buttonStyle(.plain)

                        NavigationLink {
                            VaccinationsView()
                        } label: {
                            moreRow("Vaccinations", systemImage: "syringe")
                        }
                        .buttonStyle(.plain)
                        
                        NavigationLink {
                            UnderstandMeningitisView()
                        } label: {
                            moreRow("Understand meningitis", systemImage: "brain.head.profile")
                        }
                        .buttonStyle(.plain)

                        NavigationLink {
                            EmergencyInfoView()
                        } label: {
                            moreRow(
                                "Emergency",
                                systemImage: "exclamationmark.triangle.fill",
                                iconColor: .red
                            )
                        }
                        .buttonStyle(.plain)
                    }

                    Spacer()
                }
                .padding(.horizontal, design.horizontalPadding)
                .padding(.top, 10)
                .padding(.bottom, 20)
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }

    private var headerBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("More")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Extra guidance and information.")
                .font(.caption)
                .foregroundStyle(design.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.bottom, 8)
    }

    private func moreRow(
        _ title: String,
        systemImage: String,
        iconColor: Color? = nil
    ) -> some View {
        HStack(spacing: 12) {
            Image(systemName: systemImage)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(iconColor ?? design.teal)
                .frame(width: 22)

            Text(title)
                .font(.system(size: 16, weight: .semibold))
                .foregroundStyle(.white)

            Spacer()

            Image(systemName: "chevron.right")
                .font(.system(size: 13, weight: .semibold))
                .foregroundStyle(.white.opacity(0.32))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 15)
        .background(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .fill(design.cardFill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 18, style: .continuous)
                .stroke(.white.opacity(0.05), lineWidth: 1)
        )
    }
}

private struct Design {
    let horizontalPadding: CGFloat = 16

    let background = Color(red: 0.04, green: 0.07, blue: 0.11)
    let cardFill = Color(red: 0.09, green: 0.13, blue: 0.19)
    let teal = Color(red: 0.18, green: 0.78, blue: 0.76)
    let secondaryText = Color.white.opacity(0.68)
}

#Preview {
    MoreView()
}
