import SwiftUI

struct UrgentView: View {
    let onEditSymptoms: () -> Void
    let onRestart: () -> Void

    var body: some View {
        ResultScreen(
            accent: .orange,
            iconName: "cross.case.fill",
            title: "Urgent",
            subtitle: "Get help today.",
            actionTitle: "What to do now",
            actionItems: [
                "Get medical help today.",
                "Do not leave this until later.",
                "Go to A&E if symptoms worsen or new red flags appear."
            ],
            primaryButtonTitle: "Edit",
            secondaryButtonTitle: "Restart",
            onPrimary: onEditSymptoms,
            onSecondary: onRestart
        )
    }
}

#Preview {
    UrgentView(
        onEditSymptoms: {},
        onRestart: {}
    )
}
