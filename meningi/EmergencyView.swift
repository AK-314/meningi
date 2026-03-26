import SwiftUI
import UIKit

struct EmergencyView: View {
    let onRestart: () -> Void

    var body: some View {
        ResultScreen(
            accent: .red,
            iconName: "exclamationmark.triangle.fill",
            title: "Emergency",
            subtitle: "Do not wait.",
            actionTitle: "What to do now",
            actionItems: [
                "Call 999 now.",
                "Mention possible meningitis or sepsis.",
                "Go to A&E immediately if needed.",
                "Do not wait for more symptoms."
            ],
            primaryButtonTitle: "Call 999 now",
            secondaryButtonTitle: "Restart",
            onPrimary: callEmergency,
            onSecondary: onRestart
        )
    }

    private func callEmergency() {
        if let url = URL(string: "tel://999") {
            UIApplication.shared.open(url)
        }
    }
}

#Preview {
    EmergencyView(
        onRestart: {}
    )
}
