import SwiftUI

struct SeekAdviceView: View {
    let onEditSymptoms: () -> Void
    let onRestart: () -> Void

    var body: some View {
        ZStack {
            background
                .ignoresSafeArea()

            VStack(spacing: 0) {
                Spacer(minLength: 36)

                VStack(spacing: 18) {
                    ZStack {
                        Circle()
                            .fill(Color.yellow.opacity(0.16))
                            .frame(width: 120, height: 120)

                        Circle()
                            .stroke(Color.yellow.opacity(0.35), lineWidth: 1)
                            .frame(width: 120, height: 120)

                        Image(systemName: "phone.fill")
                            .font(.system(size: 40, weight: .semibold))
                            .foregroundStyle(.white)
                    }

                    VStack(spacing: 8) {
                        Text("Seek advice")
                            .font(.system(size: 34, weight: .bold, design: .rounded))
                            .foregroundStyle(.white)

                        Text("Get medical advice soon.")
                            .font(.system(size: 17, weight: .semibold))
                            .foregroundStyle(.yellow.opacity(0.95))
                    }
                }

                Spacer(minLength: 28)

                VStack(alignment: .leading, spacing: 16) {
                    Text("What to do now")
                        .font(.headline.weight(.semibold))
                        .foregroundStyle(.white)

                    VStack(alignment: .leading, spacing: 12) {
                        actionRow("Contact a doctor or NHS 111.")
                        actionRow("Watch for worsening symptoms or new red flags.")
                        actionRow("Seek urgent help if it becomes more serious.")
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

                HStack(spacing: 10) {
                    Button {
                        onEditSymptoms()
                    } label: {
                        Text("Edit")
                            .font(.headline.weight(.semibold))
                            .foregroundStyle(.black.opacity(0.82))
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 16, style: .continuous)
                                    .fill(Color.yellow)
                            )
                    }
                    .buttonStyle(.plain)

                    Button {
                        onRestart()
                    } label: {
                        Text("Restart")
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
                .padding(.horizontal, 20)
                .padding(.bottom, 22)
            }
        }
    }

    private var background: some View {
        LinearGradient(
            colors: [
                Color(red: 0.08, green: 0.08, blue: 0.06),
                Color(red: 0.05, green: 0.05, blue: 0.03),
                Color.black
            ],
            startPoint: .topLeading,
            endPoint: .bottomTrailing
        )
        .overlay {
            RadialGradient(
                colors: [
                    Color.yellow.opacity(0.12),
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
                .fill(Color.yellow)
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
    SeekAdviceView(
        onEditSymptoms: {},
        onRestart: {}
    )
}
