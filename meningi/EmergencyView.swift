import SwiftUI

struct EmergencyView: View {
    @Binding var selectedTab: Int

    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer(minLength: 28)

                VStack(spacing: 14) {
                    ZStack {
                        Circle()
                            .fill(Color.red.opacity(0.18))
                            .frame(width: 112, height: 112)

                        Circle()
                            .stroke(Color.red.opacity(0.42), lineWidth: 1.2)
                            .frame(width: 112, height: 112)

                        Image(systemName: "exclamationmark.triangle.fill")
                            .font(.system(size: 38, weight: .bold))
                            .foregroundStyle(.white)
                    }

                    VStack(spacing: 8) {
                        Text("Emergency")
                            .font(.system(size: 36, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)

                        Text("Do not wait.")
                            .font(.system(size: 18, weight: .bold))
                            .foregroundStyle(.red.opacity(0.95))
                    }
                }
                .padding(.horizontal, 20)

                Spacer(minLength: 14)

                VStack(alignment: .leading, spacing: 16) {
                    Text("What to do now")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)

                    VStack(alignment: .leading, spacing: 12) {
                        actionRow("Call 999 now.")
                        actionRow("Mention possible meningitis or sepsis.")
                        actionRow("Go to A&E immediately if needed.")
                        actionRow("Do not wait for more symptoms.")
                    }
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .fill(Color.white.opacity(0.07))
                )
                .overlay(
                    RoundedRectangle(cornerRadius: 22, style: .continuous)
                        .stroke(Color.white.opacity(0.07), lineWidth: 1)
                )
                .padding(.horizontal, 20)

                Spacer()

                VStack(spacing: 12) {
                    Button {
                        callEmergency()
                    } label: {
                        Text("Call 999 now")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.red)
                            )
                    }
                    .buttonStyle(.plain)

                }
                .padding(.horizontal, 20)
                .padding(.bottom, 12)
            }

            VStack {
                HStack {
                    Spacer()

                    Button {
                        selectedTab = 0
                    } label: {
                        Image(systemName: "xmark")
                            .font(.system(size: 14, weight: .bold))
                            .foregroundStyle(.white.opacity(0.9))
                            .frame(width: 34, height: 34)
                            .background(Color.white.opacity(0.10))
                            .clipShape(Circle())
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.10), lineWidth: 1)
                            )
                    }
                    .padding(.top, 8)
                    .padding(.trailing, 16)
                }

                Spacer()
            }
        }
        .toolbar(.hidden, for: .tabBar)
    }

    private var background: some View {
        LinearGradient(
            colors: [
                Color(red: 0.09, green: 0.04, blue: 0.05),
                Color(red: 0.05, green: 0.02, blue: 0.03),
                Color.black
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay {
            RadialGradient(
                colors: [
                    Color.red.opacity(0.16),
                    Color.clear
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
                .fill(Color.red)
                .frame(width: 8, height: 8)
                .padding(.top, 6)

            Text(text)
                .font(.system(size: 16))
                .foregroundStyle(.white.opacity(0.88))
                .fixedSize(horizontal: false, vertical: true)
        }
    }

    private func callEmergency() {
        if let url = URL(string: "tel://999") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    EmergencyView(selectedTab: .constant(3))
}
