import SwiftUI

struct ResultScreen: View {
    let accent: Color
    let iconName: String
    let title: String
    let subtitle: String
    let actionTitle: String
    let actionItems: [String]

    let primaryButtonTitle: String
    let secondaryButtonTitle: String?

    let onPrimary: () -> Void
    let onSecondary: (() -> Void)?

    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer()

                VStack(spacing: 28) {
                    headerSection
                    infoCard
                }
                .frame(maxWidth: 520)
                .padding(.horizontal, 20)

                Spacer(minLength: 24)

                bottomButtons
                    .frame(maxWidth: 520)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 22)
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 18) {
            ZStack {
                Circle()
                    .fill(accent.opacity(0.16))
                    .frame(width: 120, height: 120)

                Circle()
                    .stroke(accent.opacity(0.35), lineWidth: 1)
                    .frame(width: 120, height: 120)

                Image(systemName: iconName)
                    .font(.system(size: 40, weight: .semibold))
                    .foregroundStyle(.white)
            }

            VStack(spacing: 8) {
                Text(title)
                    .font(.system(size: 34, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)

                Text(subtitle)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundStyle(accent.opacity(0.95))
            }
        }
    }

    private var infoCard: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text(actionTitle)
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)

            VStack(alignment: .leading, spacing: 12) {
                ForEach(actionItems, id: \.self) { item in
                    actionRow(item)
                }
            }
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.07))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.07), lineWidth: 1)
        )
    }

    @ViewBuilder
    private var bottomButtons: some View {
        if let secondaryButtonTitle = secondaryButtonTitle,
           let onSecondary = onSecondary {
            HStack(spacing: 10) {
                primaryButton(title: primaryButtonTitle, action: onPrimary)
                secondaryButton(title: secondaryButtonTitle, action: onSecondary)
            }
        } else {
            primaryButton(title: primaryButtonTitle, action: onPrimary)
        }
    }

    private func primaryButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundStyle(.black.opacity(0.82))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(accent)
                )
        }
        .buttonStyle(.plain)
    }

    private func secondaryButton(title: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 15)
                .background(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .fill(Color.white.opacity(0.08))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 16, style: .continuous)
                        .stroke(Color.white.opacity(0.08), lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }

    private var background: some View {
        LinearGradient(
            colors: [
                Color(red: 0.06, green: 0.09, blue: 0.07),
                Color(red: 0.03, green: 0.05, blue: 0.04),
                Color.black
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay {
            RadialGradient(
                colors: [
                    accent.opacity(0.12),
                    .clear
                ],
                center: .top,
                startRadius: 40,
                endRadius: 320
            )
        }
    }

    private func actionRow(_ text: String) -> some View {
        HStack(alignment: .top, spacing: 10) {
            Circle()
                .fill(accent)
                .frame(width: 8, height: 8)
                .padding(.top, 6)

            Text(text)
                .font(.system(size: 16))
                .foregroundStyle(.white.opacity(0.86))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}
