import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: Int

    var body: some View {
        GeometryReader { geometry in
            ZStack {
                background
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(spacing: 24) {
                        headerSection
                        storyCard
                        actionButtons
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, max(8, geometry.safeAreaInsets.top - 6))
                    .padding(.bottom, 24)
                    .frame(maxWidth: .infinity)
                    .frame(minHeight: geometry.size.height, alignment: .top)
                }
            }
        }
    }

    private let teal = Color(red: 0.18, green: 0.78, blue: 0.76)

    private var headerSection: some View {
        VStack(spacing: 10) {
            Text("meningi")
                .font(.system(size: 36, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("Early awareness saves lives.")
                .font(.system(size: 15, weight: .medium))
                .foregroundStyle(.white.opacity(0.68))
        }
        .multilineTextAlignment(.center)
        .frame(maxWidth: .infinity)
    }

    private var storyCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Why this app exists")
                .font(.system(size: 18, weight: .semibold))
                .foregroundStyle(.white)

            Text("My younger brother nearly died from meningitis. The early signs can look ordinary at first, and that delay can be dangerous. I made meningi to help people recognise serious symptoms faster and know when to act.")
                .font(.system(size: 15))
                .foregroundStyle(.white.opacity(0.85))
                .lineSpacing(3)

            Text("This app is not a diagnosis. It is a fast, clear awareness tool designed to help you respond sooner.")
                .font(.system(size: 14))
                .foregroundStyle(.white.opacity(0.65))
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(Color(red: 0.09, green: 0.13, blue: 0.19))
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }

    private var actionButtons: some View {
        VStack(spacing: 14) {
            Button {
                selectedTab = 1
            } label: {
                Text("Check symptoms")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundStyle(.black.opacity(0.85))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(teal)
                    )
            }
            .buttonStyle(.plain)

            Button {
                selectedTab = 2
            } label: {
                Text("Learn more")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundStyle(.white.opacity(0.86))
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
        }
    }

    private var background: some View {
        LinearGradient(
            colors: [
                Color(red: 0.05, green: 0.09, blue: 0.15),
                Color(red: 0.03, green: 0.05, blue: 0.09),
                Color(red: 0.01, green: 0.02, blue: 0.04)
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    HomeView(selectedTab: .constant(0))
}
