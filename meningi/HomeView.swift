import SwiftUI

struct HomeView: View {
    @Binding var selectedTab: Int

    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()

            ScrollView(showsIndicators: false) {
                VStack(spacing: 28) {
                    Spacer(minLength: 40)

                    headerSection

                    storyCard

                    actionButtons

                    Spacer(minLength: 30)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 24)
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 10) {
            Text("meningi")
                .font(.system(size: 38, weight: .bold, design: .rounded))
                .foregroundColor(.white)

            Text("Early awareness saves lives.")
                .font(.system(size: 15, weight: .medium))
                .foregroundColor(.white.opacity(0.68))
        }
        .multilineTextAlignment(.center)
        .padding(.top, 12)
    }

    private var storyCard: some View {
        VStack(alignment: .leading, spacing: 14) {
            Text("Why this app exists")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.white)

            Text("My younger brother nearly died from meningitis. The early signs can look ordinary at first, and that delay can be dangerous. I made meningi to help people recognise serious symptoms faster and know when to act.")
                .font(.system(size: 16))
                .foregroundColor(.white.opacity(0.82))
                .lineSpacing(4)

            Text("This app is not a diagnosis. It is a fast, clear awareness tool designed to help you respond sooner.")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(.white.opacity(0.62))
                .lineSpacing(3)
        }
        .padding(20)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .fill(Color.white.opacity(0.08))
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(Color.white.opacity(0.08), lineWidth: 1)
        )
    }

    private var actionButtons: some View {
        VStack(spacing: 14) {
            Button {
                selectedTab = 1
            } label: {
                Text("Check symptoms")
                    .font(.system(size: 18, weight: .semibold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: 16, style: .continuous)
                            .fill(Color.teal.opacity(0.9))
                    )
            }

            Button {
                selectedTab = 2
            } label: {
                Text("Learn more")
                    .font(.system(size: 17, weight: .medium))
                    .foregroundColor(.white.opacity(0.86))
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
                Color(red: 0.06, green: 0.10, blue: 0.11),
                Color(red: 0.03, green: 0.05, blue: 0.06),
                Color.black
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
    }
}

#Preview {
    HomeView(selectedTab: .constant(0))
}
