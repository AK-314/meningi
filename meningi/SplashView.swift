import SwiftUI

struct SplashView: View {
    @State private var titleOpacity: Double = 0
    @State private var subtitleOpacity: Double = 0
    @State private var lineOpacity: Double = 0
    @State private var glowOpacity: Double = 0
    @State private var titleOffset: CGFloat = 10
    @State private var pulseTrim: CGFloat = 0
    @State private var showMainApp = false

    var body: some View {
        ZStack {
            if showMainApp {
                ContentView()
                    .transition(.opacity)
            } else {
                ZStack {
                    background

                    Circle()
                        .fill(
                            RadialGradient(
                                colors: [
                                    Color.teal.opacity(0.22),
                                    Color.teal.opacity(0.08),
                                    Color.clear
                                ],
                                center: .center,
                                startRadius: 30,
                                endRadius: 260
                            )
                        )
                        .frame(width: 420, height: 420)
                        .blur(radius: 24)
                        .opacity(glowOpacity)

                    VStack(spacing: 18) {
                        ZStack {
                            ECGLineShape()
                                .trim(from: 0, to: pulseTrim)
                                .stroke(
                                    Color.teal.opacity(0.9),
                                    style: StrokeStyle(lineWidth: 2.5, lineCap: .round, lineJoin: .round)
                                )
                                .frame(width: 220, height: 48)
                                .shadow(color: Color.teal.opacity(0.35), radius: 8, x: 0, y: 0)
                                .opacity(lineOpacity)

                            ECGLineShape()
                                .trim(from: 0, to: pulseTrim)
                                .stroke(
                                    Color.white.opacity(0.35),
                                    style: StrokeStyle(lineWidth: 1, lineCap: .round, lineJoin: .round)
                                )
                                .frame(width: 220, height: 48)
                                .opacity(lineOpacity * 0.8)
                        }

                        VStack(spacing: 8) {
                            Text("meningi")
                                .font(.system(size: 38, weight: .bold, design: .rounded))
                                .foregroundStyle(
                                    LinearGradient(
                                        colors: [
                                            Color.white.opacity(0.98),
                                            Color.white.opacity(0.82)
                                        ],
                                        startPoint: .top,
                                        endPoint: .bottom
                                    )
                                )
                                .tracking(0.4)
                                .opacity(titleOpacity)
                                .offset(y: titleOffset)

                            Text("Early awareness saves lives.")
                                .font(.system(size: 15, weight: .medium))
                                .foregroundColor(.white.opacity(0.64))
                                .opacity(subtitleOpacity)
                        }
                    }
                    .padding(.horizontal, 24)
                }
                .ignoresSafeArea()
                .onAppear {
                    animateSplash()
                }
            }
        }
        .animation(.easeInOut(duration: 0.3), value: showMainApp)
    }

    private var background: some View {
        ZStack {
            LinearGradient(
                colors: [
                    Color(red: 0.06, green: 0.10, blue: 0.11),
                    Color(red: 0.03, green: 0.05, blue: 0.06),
                    Color.black
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )

            LinearGradient(
                colors: [
                    Color.white.opacity(0.03),
                    Color.clear,
                    Color.black.opacity(0.14)
                ],
                startPoint: .top,
                endPoint: .bottom
            )
        }
    }

    private func animateSplash() {
        withAnimation(.easeOut(duration: 0.35)) {
            glowOpacity = 1
            titleOpacity = 1
            titleOffset = 0
        }

        withAnimation(.easeOut(duration: 0.25)) {
            lineOpacity = 1
        }

        withAnimation(.easeInOut(duration: 0.7)) {
            pulseTrim = 1
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.18) {
            withAnimation(.easeOut(duration: 0.3)) {
                subtitleOpacity = 1
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.35) {
            showMainApp = true
        }
    }
}

struct ECGLineShape: Shape {
    func path(in rect: CGRect) -> Path {
        var path = Path()

        let w = rect.width
        let h = rect.height
        let midY = h * 0.55

        path.move(to: CGPoint(x: 0.00 * w, y: midY))
        path.addLine(to: CGPoint(x: 0.18 * w, y: midY))
        path.addLine(to: CGPoint(x: 0.24 * w, y: midY - 4))
        path.addLine(to: CGPoint(x: 0.30 * w, y: midY + 6))
        path.addLine(to: CGPoint(x: 0.38 * w, y: midY - 24))
        path.addLine(to: CGPoint(x: 0.46 * w, y: midY + 12))
        path.addLine(to: CGPoint(x: 0.54 * w, y: midY))
        path.addLine(to: CGPoint(x: 1.00 * w, y: midY))

        return path
    }
}

#Preview {
    SplashView()
}
