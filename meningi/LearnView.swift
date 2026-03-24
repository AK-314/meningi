//
//  LearnView.swift
//  meningi
//

import SwiftUI

struct LearnView: View {
    private let design = Design()

    var body: some View {
        NavigationStack {
            ZStack {
                design.background
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: design.sectionSpacing) {
                        introSection

                        infoCard(
                            title: "Common warning signs",
                            icon: "eye.fill",
                            accent: design.teal
                        ) {
                            bulletList([
                                "fever",
                                "bad or unusual headache",
                                "stiff neck",
                                "sensitivity to light",
                                "vomiting",
                                "drowsiness or hard to wake",
                                "confusion"
                            ])
                        }

                        infoCard(
                            title: "Possible sepsis signs",
                            icon: "cross.case.fill",
                            accent: design.teal
                        ) {
                            bulletList([
                                "cold hands and feet",
                                "rapid breathing",
                                "pale, blue, or mottled skin",
                                "severe limb or muscle pain",
                                "symptoms worsening quickly"
                            ])
                        }

                        emergencyBox
                    }
                    .padding(.horizontal, design.horizontalPadding)
                    .padding(.top, 20)
                    .padding(.bottom, 32)
                }
            }
            .navigationTitle("Learn")
            .navigationBarTitleDisplayMode(.inline)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(design.background, for: .navigationBar)
        }
    }
}

// MARK: - UI

private extension LearnView {

    var introSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                ZStack {
                    Circle()
                        .fill(design.teal.opacity(0.16))
                        .frame(width: 38, height: 38)

                    Image(systemName: "waveform.path.ecg")
                        .font(.system(size: 17, weight: .bold))
                        .foregroundStyle(design.teal)
                }

                Text("Know the signs. Act early.")
                    .font(.system(size: 30, weight: .bold, design: .rounded))
                    .foregroundStyle(.white)
            }

            Text("Meningitis can become serious quickly. Early symptoms may look like flu or a general infection.")
                .font(.subheadline)
                .foregroundStyle(design.secondaryText)

            Text("Sepsis can also develop, which is why breathing, circulation, and skin changes matter.")
                .font(.subheadline)
                .foregroundStyle(design.secondaryText)
        }
        .padding(18)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [
                    design.cardTop,
                    design.cardBottom
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 22, style: .continuous)
                .stroke(design.teal.opacity(0.18), lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: 22, style: .continuous))
        .shadow(color: .black.opacity(0.22), radius: 18, y: 8)
    }

    func infoCard<Content: View>(
        title: String,
        icon: String,
        accent: Color,
        @ViewBuilder content: () -> Content
    ) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(accent.opacity(0.16))
                        .frame(width: 34, height: 34)

                    Image(systemName: icon)
                        .font(.system(size: 15, weight: .bold))
                        .foregroundStyle(accent)
                }

                Text(title)
                    .font(.headline.weight(.semibold))
                    .foregroundStyle(.white)
            }

            content()
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .fill(design.cardFill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(.white.opacity(0.05), lineWidth: 1)
        )
        .shadow(color: .black.opacity(0.18), radius: 14, y: 6)
    }

    var emergencyBox: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 10) {
                ZStack {
                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                        .fill(Color.red.opacity(0.18))
                        .frame(width: 36, height: 36)

                    Image(systemName: "exclamationmark.triangle.fill")
                        .font(.system(size: 16, weight: .bold))
                        .foregroundStyle(Color.red.opacity(0.95))
                }

                Text("Get urgent help now")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
            }

            Text("Call emergency services or seek urgent medical help immediately if there is a non-blanching rash, seizure, severe breathing difficulty, confusion, unresponsiveness, or rapidly worsening symptoms.")
                .font(.subheadline)
                .foregroundStyle(design.bodyText)

            Text("Do not wait for more symptoms.")
                .font(.subheadline.weight(.bold))
                .foregroundStyle(.white)
        }
        .padding(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            LinearGradient(
                colors: [
                    Color.red.opacity(0.16),
                    Color.red.opacity(0.08)
                ],
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .overlay(
            RoundedRectangle(cornerRadius: 20, style: .continuous)
                .stroke(Color.red.opacity(0.55), lineWidth: 1.3)
        )
        .clipShape(RoundedRectangle(cornerRadius: 20, style: .continuous))
        .shadow(color: Color.red.opacity(0.12), radius: 12, y: 4)
    }

    func bulletList(_ items: [String]) -> some View {
        VStack(alignment: .leading, spacing: 12) {
            ForEach(items, id: \.self) { item in
                HStack(alignment: .top, spacing: 10) {
                    Circle()
                        .fill(design.teal)
                        .frame(width: 6, height: 6)
                        .padding(.top, 7)

                    Text(item.capitalizedSentence)
                        .foregroundStyle(design.bodyText)
                        .frame(maxWidth: .infinity, alignment: .leading)
                }
                .font(.body)
            }
        }
    }
}

// MARK: - Design

private struct Design {
    let horizontalPadding: CGFloat = 16
    let sectionSpacing: CGFloat = 18

    let background = Color(red: 0.05, green: 0.06, blue: 0.08)

    let cardFill = Color(red: 0.10, green: 0.11, blue: 0.14)
    let cardTop = Color(red: 0.12, green: 0.13, blue: 0.17)
    let cardBottom = Color(red: 0.09, green: 0.10, blue: 0.13)

    let teal = Color(red: 0.18, green: 0.78, blue: 0.76)

    let bodyText = Color.white.opacity(0.92)
    let secondaryText = Color.white.opacity(0.68)
}

// MARK: - Helpers

private extension String {
    var capitalizedSentence: String {
        prefix(1).uppercased() + dropFirst()
    }
}

#Preview {
    LearnView()
}
