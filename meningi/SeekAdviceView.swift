import SwiftUI

struct SeekAdviceView: View {
    let onEditSymptoms: () -> Void
    let onRestart: () -> Void

    var body: some View {
        ResultScreen(
            accent: .yellow,
            iconName: "phone.fill",
            title: "Seek advice",
            subtitle: "Get medical advice soon.",
            actionTitle: "What to do now",
            actionItems: [
                "Contact a doctor or NHS 111.",
                "Watch for worsening symptoms or new red flags.",
                "Seek urgent help if it becomes more serious."
            ],
            primaryButtonTitle: "Edit",
            secondaryButtonTitle: "Restart",
            onPrimary: onEditSymptoms,
            onSecondary: onRestart
        )
    }
}

#Preview {
    SeekAdviceView(
        onEditSymptoms: {},
        onRestart: {}
    )
}
