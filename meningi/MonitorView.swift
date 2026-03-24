import SwiftUI

struct MonitorView: View {
    @Environment(\.dismiss) private var dismiss

    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer(minLength: 36)

                VStack(spacing: 18) {
                    ZStack {
                        Circle()
                            .fill(Color.green.opacity(0.16))
                            .frame(width: 120, height: 120)

                        Circle()
                            .stroke(Color.green.opacity(0.35), lineWidth: 1)
                            .frame(width: 120, height: 120)

                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 40, weight: .semibold))
                            .foregroundStyle(.white)
                    }

                    VStack(spacing: 8) {
                        Text("Monitor")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)

                        Text("Keep watching closely.")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.green.opacity(0.95))
                    }
                }

                Spacer(minLength: 28)

                VStack(alignment: .leading, spacing: 16) {
                    Text("What to do now")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)

                    VStack(alignment: .leading, spacing: 12) {
                        actionRow("Keep monitoring symptoms.")
                        actionRow("Get help if symptoms worsen or new red flags appear.")
                        actionRow("Repeat the check or seek medical advice if concerned.")
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
                .padding(.horizontal, 20)

                Spacer()

                VStack(spacing: 12) {
                    Button {
                        dismiss()
                    } label: {
                        Text("Back to symptoms")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(.black.opacity(0.82))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 16)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.green)
                            )
                    }
                    .buttonStyle(.plain)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 22)
            }
        }
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
                    Color.green.opacity(0.12),
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
                .fill(Color.green)
                .frame(width: 8, height: 8)
                .padding(.top, 6)

            Text(text)
                .font(.system(size: 16))
                .foregroundStyle(.white.opacity(0.86))
                .fixedSize(horizontal: false, vertical: true)
        }
    }
}

#Preview {
    MonitorView()
}
