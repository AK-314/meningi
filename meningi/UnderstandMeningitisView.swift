//
//  UnderstandMeningitisView.swift
//  meningi
//
//  Created by Alex Kolesnikov on 27/03/2026.
//


import SwiftUI

struct UnderstandMeningitisView: View {
    private let design = Design()

    var body: some View {
        NavigationStack {
            ZStack {
                design.background
                    .ignoresSafeArea()

                ScrollView(showsIndicators: false) {
                    VStack(alignment: .leading, spacing: design.sectionSpacing) {
                        headerBlock

                        introCard

                        infoCard(
                            title: "What meningitis is",
                            icon: "brain.head.profile",
                            accent: design.teal
                        ) {
                            Text("Meningitis is inflammation of the lining around the brain and spinal cord. It can be caused by infections such as viruses or bacteria.")
                                .foregroundStyle(design.bodyText)
                                .font(.body)
                        }

                        infoCard(
                            title: "Why it can be dangerous",
                            icon: "bolt.heart.fill",
                            accent: design.sepsisOrange
                        ) {
                            VStack(alignment: .leading, spacing: 10) {
                                bodyLine("The illness can worsen quickly.")
                                bodyLine("Swelling and infection can affect the brain, nerves, and the rest of the body.")
                                bodyLine("Sepsis can also develop, which is a medical emergency.")
                            }
                        }

                        infoCard(
                            title: "Why it is sometimes missed",
                            icon: "eye.trianglebadge.exclamationmark",
                            accent: design.teal
                        ) {
                            VStack(alignment: .leading, spacing: 10) {
                                bodyLine("Early symptoms may look like flu or a general infection.")
                                bodyLine("Not every symptom appears at once.")
                                bodyLine("Different people can show different patterns.")
                                bodyLine("A rash may appear late or not at all.")
                            }
                        }

                        infoCard(
                            title: "Viral vs bacterial meningitis",
                            icon: "cross.case.fill",
                            accent: design.teal
                        ) {
                            VStack(alignment: .leading, spacing: 10) {
                                bodyLine("Viral meningitis is often less severe, though it can still make someone very unwell.")
                                bodyLine("Bacterial meningitis is more dangerous and needs urgent treatment.")
                                bodyLine("You cannot safely tell the difference just by guessing at home.")
                            }
                        }

                        infoCard(
                            title: "What matters most",
                            icon: "clock.badge.exclamationmark",
                            accent: design.sepsisOrange
                        ) {
                            VStack(alignment: .leading, spacing: 10) {
                                bodyLine("Recognise concerning symptoms early.")
                                bodyLine("Take rapid worsening seriously.")
                                bodyLine("Get urgent medical help if someone seems seriously unwell.")
                            }
                        }

                        emergencyBox
                    }
                    .padding(.horizontal, design.horizontalPadding)
                    .padding(.top, 10)
                    .padding(.bottom, 32)
                }
            }
            .toolbar(.hidden, for: .navigationBar)
        }
    }
}

// MARK: - UI

private extension UnderstandMeningitisView {

    var headerBlock: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text("Understand meningitis")
                .font(.system(size: 28, weight: .bold, design: .rounded))
                .foregroundStyle(.white)

            Text("A deeper explanation, without turning into a textbook.")
                .font(.caption)
                .foregroundStyle(design.secondaryText)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    var introCard: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("This page is here to explain the bigger picture.")
                .font(.headline.weight(.semibold))
                .foregroundStyle(.white)

            Text("The goal is not to memorise facts. It is to understand why meningitis can be missed, why speed matters, and why symptoms should be taken seriously.")
                .font(.subheadline)
                .foregroundStyle(design.secondaryText)
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
    }

    func bodyLine(_ text: String) -> some View {
        Text(text)
            .foregroundStyle(design.bodyText)
            .font(.body)
            .frame(maxWidth: .infinity, alignment: .leading)
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

                Text("Urgent action matters")
                    .font(.headline.weight(.bold))
                    .foregroundStyle(.white)
            }

            Text("If someone has a non-blanching rash, seizure, severe breathing difficulty, confusion, is hard to wake, or is worsening quickly, get urgent medical help immediately.")
                .font(.subheadline)
                .foregroundStyle(design.bodyText)

            Text("Do not wait for every symptom to appear.")
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
    }
}

// MARK: - Design

private struct Design {
    let horizontalPadding: CGFloat = 16
    let sectionSpacing: CGFloat = 18

    let background = Color(red: 0.04, green: 0.07, blue: 0.11)
    let cardFill = Color(red: 0.09, green: 0.13, blue: 0.19)

    let teal = Color(red: 0.18, green: 0.78, blue: 0.76)
    let sepsisOrange = Color(red: 0.96, green: 0.56, blue: 0.20)

    let bodyText = Color.white.opacity(0.92)
    let secondaryText = Color.white.opacity(0.68)
}

#Preview {
    UnderstandMeningitisView()
}