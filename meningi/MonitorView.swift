import SwiftUI

struct MonitorView: View {
    let onEditSymptoms: () -> Void
    let onRestart: () -> Void

    var body: some View {
        ResultScreen(
            accent: .green,
            iconName: "checkmark.circle.fill",
            title: "Monitor",
            subtitle: "Keep watching closely.",
            actionTitle: "What to do now",
            actionItems: [
                "Keep monitoring symptoms.",
                "Get help if symptoms worsen or new red flags appear.",
                "Repeat the check or seek medical advice if concerned."
            ],
            primaryButtonTitle: "Edit",
            secondaryButtonTitle: "Restart",
            onPrimary: onEditSymptoms,
            onSecondary: onRestart
        )
    }
}

#Preview {
    MonitorView(
        onEditSymptoms: {},
        onRestart: {}
    )
}
